#![allow(dead_code)]

use crate::auth::{JwtClient, JwtVerifier, authentication_token};
use crate::client::execution_service_client::SagittariusRailsExecutionServiceClient;
use crate::client::token_service_client::{
    RuntimeVerificationStatus, SagittariusRailsTokenServiceClient,
};
use std::collections::HashMap;
use std::pin::Pin;
use std::sync::Arc;
use tokio::sync::{Mutex, mpsc};
use tonic::codegen::tokio_stream::Stream;
use tonic::codegen::tokio_stream::wrappers::ReceiverStream;
use tonic::metadata::MetadataMap;
use tonic::{Extensions, Response, Status};
use tucana::sagittarius_gateway::execution_logon_request::Data;
use tucana::sagittarius_gateway::execution_service_server::ExecutionService;
use tucana::sagittarius_gateway::{
    ExecutionLogonRequest, ExecutionLogonResponse, ExecutionPushRequest, ExecutionPushResponse,
    TestExecutionRequest,
};
use tucana::sagittarius_rails::ExecutionRequest;

const EXECUTION_QUEUE_CAPACITY: usize = 1024;

pub struct SagittariusExecutionService {
    client: SagittariusRailsExecutionServiceClient,
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
    jwt_verifier: JwtVerifier,
    streams: Arc<Mutex<HashMap<i64, ExecutionResponseSender>>>,
}

type ExecutionUpdateStream =
    Pin<Box<dyn Stream<Item = Result<ExecutionLogonResponse, tonic::Status>> + Send + 'static>>;

type ExecutionResponseSender = mpsc::Sender<Result<ExecutionLogonResponse, tonic::Status>>;

impl SagittariusExecutionService {
    pub fn new(
        client: SagittariusRailsExecutionServiceClient,
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
        streams: Arc<Mutex<HashMap<i64, ExecutionResponseSender>>>,
        client: SagittariusRailsExecutionServiceClient,
        jwt_client: JwtClient,
        mut incoming_stream: tonic::Streaming<ExecutionLogonRequest>,
    ) {
        loop {
            match incoming_stream.message().await {
                Ok(Some(message)) => Self::handle_aquila_message(
                    client.clone(),
                    jwt_client.clone(),
                    runtime_id,
                    message,
                ),
                Ok(None) => break,
                Err(err) => {
                    log::error!("Failed to receive execution update from Aquila: {}", err);
                    break;
                }
            }
        }

        streams.lock().await.remove(&runtime_id);
        log::info!("Aquila execution stream closed for runtime {}.", runtime_id);
    }

    fn handle_aquila_message(
        client: SagittariusRailsExecutionServiceClient,
        jwt_client: JwtClient,
        runtime_id: i64,
        message: ExecutionLogonRequest,
    ) {
        match message.data {
            Some(Data::Response(response)) => {
                // Rails is a separate unary RPC. It is spawned from here so slow
                // Rails calls do not hold up Aquila's stream reader.
                tokio::spawn(async move {
                    let authorization = match jwt_client.authorization_for_runtime(runtime_id) {
                        Ok(authorization) => authorization,
                        Err(err) => {
                            log::error!("Failed to authenticate execution response: {}", err);
                            return;
                        }
                    };
                    let rails_request = ExecutionRequest {
                        response: Some(response),
                    };

                    if let Err(err) = client.update(rails_request, authorization).await {
                        log::error!("Failed to proxy execution response to Rails: {}", err);
                    }
                });
            }
            Some(Data::Logon(_)) => {
                log::info!("Aquila execution stream logon received.");
            }
            None => {
                log::warn!("Received empty execution update from Aquila.");
            }
        }
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
        streams: &Arc<Mutex<HashMap<i64, ExecutionResponseSender>>>,
        runtime_id: i64,
        sender: ExecutionResponseSender,
    ) -> Result<(), Status> {
        let mut streams = streams.lock().await;

        if streams.contains_key(&runtime_id) {
            return Err(Status::already_exists(
                "Aquila execution stream is already connected for runtime",
            ));
        }

        streams.insert(runtime_id, sender);
        Ok(())
    }

    async fn stream_for_runtime(&self, runtime_id: i64) -> Result<ExecutionResponseSender, Status> {
        self.streams
            .lock()
            .await
            .get(&runtime_id)
            .cloned()
            .ok_or_else(|| {
                Status::unavailable(format!(
                    "no Aquila execution stream connected for runtime {runtime_id}"
                ))
            })
    }

    async fn send_to_aquila_stream(
        outgoing_stream: &ExecutionResponseSender,
        request: TestExecutionRequest,
    ) -> Result<(), mpsc::error::SendError<Result<ExecutionLogonResponse, tonic::Status>>> {
        outgoing_stream
            .send(Ok(ExecutionLogonResponse {
                request: Some(request),
            }))
            .await
    }

    fn empty_push_response() -> tonic::Response<ExecutionPushResponse> {
        Response::from_parts(
            MetadataMap::new(),
            ExecutionPushResponse {},
            Extensions::new(),
        )
    }

    fn extract_test_execution(
        request: tonic::Request<ExecutionPushRequest>,
    ) -> Option<TestExecutionRequest> {
        request.into_inner().request
    }
}

#[tonic::async_trait]
impl ExecutionService for SagittariusExecutionService {
    type UpdateStream = ExecutionUpdateStream;

    async fn update(
        &self,
        request: tonic::Request<tonic::Streaming<ExecutionLogonRequest>>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        let (metadata, _, incoming_stream) = request.into_parts();
        let runtime_id = Self::verify_stream_runtime(&self.token_client, &metadata).await?;
        let (response_tx, response_rx) = mpsc::channel(EXECUTION_QUEUE_CAPACITY);

        Self::register_stream(&self.streams, runtime_id, response_tx).await?;

        log::info!(
            "Aquila execution stream connected for runtime {}.",
            runtime_id
        );

        tokio::spawn(Self::run_update_stream(
            runtime_id,
            Arc::clone(&self.streams),
            self.client.clone(),
            self.jwt_client.clone(),
            incoming_stream,
        ));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    async fn push(
        &self,
        request: tonic::Request<ExecutionPushRequest>,
    ) -> Result<tonic::Response<ExecutionPushResponse>, tonic::Status> {
        let runtime_id = self
            .jwt_verifier
            .runtime_id_from_metadata(request.metadata())?;

        let Some(test_execution) = Self::extract_test_execution(request) else {
            return Ok(Self::empty_push_response());
        };

        let stream = self.stream_for_runtime(runtime_id).await?;
        if Self::send_to_aquila_stream(&stream, test_execution)
            .await
            .is_err()
        {
            self.streams.lock().await.remove(&runtime_id);
            return Err(Status::unavailable(format!(
                "Aquila execution stream closed for runtime {runtime_id}"
            )));
        }

        log::info!(
            "Received test execution request, will proxy request to Aquila runtime {}.",
            runtime_id
        );
        Ok(Self::empty_push_response())
    }
}
