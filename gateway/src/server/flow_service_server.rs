#![allow(dead_code)]

use crate::auth::{JwtClient, JwtVerifier, authentication_token};
use crate::client::flow_service_client::SagittariusRailsFlowServiceClient;
use crate::client::token_service_client::{
    RuntimeVerificationStatus, SagittariusRailsTokenServiceClient,
};
use std::collections::HashMap;
use std::pin::Pin;
use std::sync::Arc;

use tokio::sync::{Mutex, mpsc};
use tonic::codegen::tokio_stream::Stream;
use tonic::codegen::tokio_stream::wrappers::ReceiverStream;
use tonic::metadata::{MetadataMap, MetadataValue};
use tonic::{Extensions, Response, Status};
use tucana::sagittarius_gateway::flow_response as gateway_flow_response;
use tucana::sagittarius_gateway::flow_service_server::FlowService;
use tucana::sagittarius_gateway::{
    FlowLogonRequest, FlowPushRequest, FlowPushResponse, FlowResponse,
};
use tucana::sagittarius_rails::flow_response as rails_flow_response;
use tucana::sagittarius_rails::{
    FlowLogonRequest as RailsFlowLogonRequest, FlowResponse as RailsFlowResponse,
};

const FLOW_QUEUE_CAPACITY: usize = 1024;

pub struct SagittariusFlowService {
    client: SagittariusRailsFlowServiceClient,
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
    jwt_verifier: JwtVerifier,
    streams: Arc<Mutex<HashMap<i64, FlowResponseSender>>>,
}

type FlowUpdateStream =
    Pin<Box<dyn Stream<Item = Result<FlowResponse, tonic::Status>> + Send + 'static>>;

type FlowResponseSender = mpsc::Sender<Result<FlowResponse, tonic::Status>>;

impl SagittariusFlowService {
    pub fn new(
        client: SagittariusRailsFlowServiceClient,
        token_client: SagittariusRailsTokenServiceClient,
        jwt_client: JwtClient,
        jwt_verifier: JwtVerifier,
    ) -> Self {
        Self {
            client,
            token_client,
            jwt_client,
            jwt_verifier,
            streams: Arc::new(Mutex::new(HashMap::new())),
        }
    }

    async fn run_update_stream(
        runtime_id: i64,
        streams: Arc<Mutex<HashMap<i64, FlowResponseSender>>>,
        client: SagittariusRailsFlowServiceClient,
        outgoing_stream: FlowResponseSender,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) {
        if Self::send_initial_flow_state(client, &outgoing_stream, authorization)
            .await
            .is_err()
        {
            streams.lock().await.remove(&runtime_id);
            return;
        }

        outgoing_stream.closed().await;
        streams.lock().await.remove(&runtime_id);
        log::info!("Aquila flow stream closed for runtime {}.", runtime_id);
    }

    async fn send_initial_flow_state(
        client: SagittariusRailsFlowServiceClient,
        outgoing_stream: &FlowResponseSender,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<(), ()> {
        let rails_response = match client.update(RailsFlowLogonRequest {}, authorization).await {
            Ok(response) => response.into_inner(),
            Err(err) => {
                log::error!("Failed to fetch initial flow state from Rails: {}", err);
                let _ = outgoing_stream.send(Err(err)).await;
                return Err(());
            }
        };

        Self::send_to_aquila_stream(outgoing_stream, Self::from_rails_response(rails_response))
            .await
            .map_err(|_| {
                log::info!("Aquila flow stream closed before initial state could be sent.");
            })
    }

    async fn verify_stream_runtime(
        token_client: &SagittariusRailsTokenServiceClient,
        metadata: &MetadataMap,
    ) -> Result<i64, Status> {
        let token = authentication_token(metadata)?;

        match token_client.validate_token(token).await {
            RuntimeVerificationStatus::Verified { runtime_id } => Ok(runtime_id),
            RuntimeVerificationStatus::Unverified => Err(Status::unauthenticated(
                "invalid Aquila authentication token",
            )),
        }
    }

    async fn register_stream(
        streams: &Arc<Mutex<HashMap<i64, FlowResponseSender>>>,
        runtime_id: i64,
        sender: FlowResponseSender,
    ) -> Result<(), Status> {
        let mut streams = streams.lock().await;

        if streams.contains_key(&runtime_id) {
            return Err(Status::already_exists(
                "Aquila flow stream is already connected for runtime",
            ));
        }

        streams.insert(runtime_id, sender);
        Ok(())
    }

    async fn stream_for_runtime(&self, runtime_id: i64) -> Result<FlowResponseSender, Status> {
        self.streams
            .lock()
            .await
            .get(&runtime_id)
            .cloned()
            .ok_or_else(|| {
                Status::unavailable(format!(
                    "no Aquila flow stream connected for runtime {runtime_id}"
                ))
            })
    }

    async fn send_to_aquila_stream(
        outgoing_stream: &FlowResponseSender,
        response: FlowResponse,
    ) -> Result<(), mpsc::error::SendError<Result<FlowResponse, tonic::Status>>> {
        outgoing_stream.send(Ok(response)).await
    }

    fn from_rails_response(response: RailsFlowResponse) -> FlowResponse {
        FlowResponse {
            data: response.data.map(|data| match data {
                rails_flow_response::Data::UpdatedFlow(flow) => {
                    gateway_flow_response::Data::UpdatedFlow(flow)
                }
                rails_flow_response::Data::DeletedFlowId(flow_id) => {
                    gateway_flow_response::Data::DeletedFlowId(flow_id)
                }
                rails_flow_response::Data::Flows(flows) => {
                    gateway_flow_response::Data::Flows(flows)
                }
            }),
        }
    }

    fn empty_push_response() -> tonic::Response<FlowPushResponse> {
        Response::from_parts(MetadataMap::new(), FlowPushResponse {}, Extensions::new())
    }

    fn extract_flow_push(request: tonic::Request<FlowPushRequest>) -> (i64, Option<FlowResponse>) {
        let request = request.into_inner();
        (request.runtime_identifier, request.response)
    }

    fn ensure_matching_runtime(
        expected_runtime_id: i64,
        request_runtime_id: i64,
    ) -> Result<(), Status> {
        if request_runtime_id != 0 && request_runtime_id != expected_runtime_id {
            return Err(Status::permission_denied(
                "request runtime does not match JWT subject",
            ));
        }

        Ok(())
    }
}

#[tonic::async_trait]
impl FlowService for SagittariusFlowService {
    type UpdateStream = FlowUpdateStream;

    async fn update(
        &self,
        request: tonic::Request<FlowLogonRequest>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        let metadata = request.metadata();
        let runtime_id = Self::verify_stream_runtime(&self.token_client, metadata).await?;
        let authorization = self.jwt_client.authorization_for_runtime(runtime_id)?;
        let (response_tx, response_rx) = mpsc::channel(FLOW_QUEUE_CAPACITY);

        Self::register_stream(&self.streams, runtime_id, response_tx.clone()).await?;

        log::info!("Aquila flow stream connected for runtime {}.", runtime_id);

        tokio::spawn(Self::run_update_stream(
            runtime_id,
            Arc::clone(&self.streams),
            self.client.clone(),
            response_tx,
            authorization,
        ));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    async fn push(
        &self,
        request: tonic::Request<FlowPushRequest>,
    ) -> Result<tonic::Response<FlowPushResponse>, tonic::Status> {
        let runtime_id = self
            .jwt_verifier
            .runtime_id_from_metadata(request.metadata())?;
        let (request_runtime_id, Some(flow_response)) = Self::extract_flow_push(request) else {
            return Ok(Self::empty_push_response());
        };
        Self::ensure_matching_runtime(runtime_id, request_runtime_id)?;

        let stream = self.stream_for_runtime(runtime_id).await?;
        if Self::send_to_aquila_stream(&stream, flow_response)
            .await
            .is_err()
        {
            self.streams.lock().await.remove(&runtime_id);
            return Err(Status::unavailable(format!(
                "Aquila flow stream closed for runtime {runtime_id}"
            )));
        }

        log::info!(
            "Received flow update request, will proxy request to Aquila runtime {}.",
            runtime_id
        );
        Ok(Self::empty_push_response())
    }
}
