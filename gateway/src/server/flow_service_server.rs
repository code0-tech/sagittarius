#![allow(dead_code)]

use crate::client::flow_service_client::SagittariusRailsFlowServiceClient;
use std::pin::Pin;
use std::sync::Arc;

use tokio::sync::{Mutex, OwnedMutexGuard, mpsc};
use tonic::codegen::tokio_stream::Stream;
use tonic::codegen::tokio_stream::wrappers::ReceiverStream;
use tonic::metadata::MetadataMap;
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
    // Push is unary while Aquila receives updates through a long-lived stream, so
    // the service needs a queue between those two different RPC shapes.
    stream_tx: mpsc::Sender<FlowResponse>,
    // There is one shared queue of flow updates for Aquila. Keeping the receiver
    // guarded here makes that single-consumer assumption explicit at the boundary.
    stream_rx: Arc<Mutex<mpsc::Receiver<FlowResponse>>>,
}

type FlowUpdateStream =
    Pin<Box<dyn Stream<Item = Result<FlowResponse, tonic::Status>> + Send + 'static>>;

type FlowResponseSender = mpsc::Sender<Result<FlowResponse, tonic::Status>>;

impl SagittariusFlowService {
    pub fn new(client: SagittariusRailsFlowServiceClient) -> Self {
        let (stream_tx, stream_rx) = mpsc::channel(FLOW_QUEUE_CAPACITY);

        Self {
            client,
            stream_tx,
            stream_rx: Arc::new(Mutex::new(stream_rx)),
        }
    }

    async fn run_update_stream(
        client: SagittariusRailsFlowServiceClient,
        mut queued_updates: OwnedMutexGuard<mpsc::Receiver<FlowResponse>>,
        outgoing_stream: FlowResponseSender,
    ) {
        if Self::send_initial_flow_state(client, &outgoing_stream)
            .await
            .is_err()
        {
            return;
        }

        while let Some(flow_response) = queued_updates.recv().await {
            if Self::send_to_aquila_stream(&outgoing_stream, flow_response)
                .await
                .is_err()
            {
                log::info!("Aquila flow stream closed.");
                return;
            }
        }

        log::info!("Flow update queue closed.");
    }

    async fn send_initial_flow_state(
        client: SagittariusRailsFlowServiceClient,
        outgoing_stream: &FlowResponseSender,
    ) -> Result<(), ()> {
        let rails_response = match client.update(RailsFlowLogonRequest {}).await {
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

    fn extract_flow_response(request: tonic::Request<FlowPushRequest>) -> Option<FlowResponse> {
        request.into_inner().response
    }
}

#[tonic::async_trait]
impl FlowService for SagittariusFlowService {
    type UpdateStream = FlowUpdateStream;

    // Aquila owns the long-lived flow stream, so this method starts the bridge
    // between Rails' initial state and later queued Sagittarius pushes.
    async fn update(
        &self,
        _request: tonic::Request<FlowLogonRequest>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        let client = self.client.clone();
        // A second Aquila stream would compete for the same flow updates and make
        // delivery semantics unclear, so reject it at connection time.
        let queued_updates = Arc::clone(&self.stream_rx)
            .try_lock_owned()
            .map_err(|_| Status::already_exists("Aquila flow stream is already connected"))?;
        let (response_tx, response_rx) = mpsc::channel(FLOW_QUEUE_CAPACITY);

        tokio::spawn(Self::run_update_stream(client, queued_updates, response_tx));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    // Sagittarius only needs an acknowledgment that the flow update was accepted
    // into the bridge. Actual delivery happens through Aquila's stream.
    async fn push(
        &self,
        request: tonic::Request<FlowPushRequest>,
    ) -> Result<tonic::Response<FlowPushResponse>, tonic::Status> {
        let Some(flow_response) = Self::extract_flow_response(request) else {
            return Ok(Self::empty_push_response());
        };

        if let Err(err) = self.stream_tx.send(flow_response).await {
            let error = format!("{:?}", err);
            log::error!("{}", &error);
            return Err(Status::internal(error));
        }

        log::info!("Received flow update request, will proxy request to Aquila.");
        Ok(Self::empty_push_response())
    }
}
