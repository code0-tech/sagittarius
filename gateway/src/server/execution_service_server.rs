#![allow(dead_code)]

use crate::client::execution_service_client::SagittariusRailsExecutionServiceClient;
use std::pin::Pin;
use std::sync::Arc;
use tokio::sync::{Mutex, OwnedMutexGuard, mpsc};
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
    // Push is unary while Aquila is connected through a long-lived stream, so the
    // service needs a queue between those two different RPC shapes.
    stream_tx: mpsc::Sender<TestExecutionRequest>,
    // There is one shared queue of work for Aquila. Keeping the receiver guarded
    // here makes that single-consumer assumption explicit at the service boundary.
    stream_rx: Arc<Mutex<mpsc::Receiver<TestExecutionRequest>>>,
}

type ExecutionUpdateStream =
    Pin<Box<dyn Stream<Item = Result<ExecutionLogonResponse, tonic::Status>> + Send + 'static>>;

type ExecutionResponseSender = mpsc::Sender<Result<ExecutionLogonResponse, tonic::Status>>;

impl SagittariusExecutionService {
    pub fn new(client: SagittariusRailsExecutionServiceClient) -> Self {
        let (stream_tx, stream_rx) = mpsc::channel(EXECUTION_QUEUE_CAPACITY);

        Self {
            client,
            stream_tx,
            stream_rx: Arc::new(Mutex::new(stream_rx)),
        }
    }

    async fn run_update_stream(
        client: SagittariusRailsExecutionServiceClient,
        mut incoming_stream: tonic::Streaming<ExecutionLogonRequest>,
        mut outgoing_requests: OwnedMutexGuard<mpsc::Receiver<TestExecutionRequest>>,
        outgoing_stream: ExecutionResponseSender,
    ) {
        loop {
            // Aquila's Update RPC is bidirectional, so its read and write sides
            // belong in the same lifecycle loop. If either side closes, the whole
            // stream should stop instead of leaving a detached half alive.
            tokio::select! {
                incoming_message = incoming_stream.message() => {
                    match incoming_message {
                        Ok(Some(message)) => Self::handle_aquila_message(client.clone(), message),
                        Ok(None) => {
                            log::info!("Aquila execution stream closed.");
                            break;
                        }
                        Err(err) => {
                            log::error!("Failed to receive execution update from Aquila: {}", err);
                            break;
                        }
                    }
                }
                outgoing_request = outgoing_requests.recv() => {
                    match outgoing_request {
                        Some(request) => {
                            if Self::send_to_aquila_stream(&outgoing_stream, request).await.is_err() {
                                log::info!("Aquila execution response stream closed.");
                                break;
                            }
                        }
                        None => {
                            log::info!("Execution request queue closed.");
                            break;
                        }
                    }
                }
            }
        }
    }

    fn handle_aquila_message(
        client: SagittariusRailsExecutionServiceClient,
        message: ExecutionLogonRequest,
    ) {
        match message.data {
            Some(Data::Response(response)) => {
                // Rails is a separate unary RPC. It is spawned from here so slow
                // Rails calls do not hold up Aquila's stream reader.
                tokio::spawn(async move {
                    let rails_request = ExecutionRequest {
                        response: Some(response),
                    };

                    if let Err(err) = client.update(rails_request).await {
                        log::error!("Failed to proxy execution response to Rails: {}", err);
                    }
                });
            }
            Some(Data::Logon(_)) => {
                log::info!("Aquila execution stream connected.");
            }
            None => {
                log::warn!("Received empty execution update from Aquila.");
            }
        }
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

    // Aquila owns the long-lived stream, so this method is where the bridge
    // between Aquila stream traffic and queued Sagittarius pushes is started.
    async fn update(
        &self,
        request: tonic::Request<tonic::Streaming<ExecutionLogonRequest>>,
    ) -> Result<tonic::Response<Self::UpdateStream>, tonic::Status> {
        let client = self.client.clone();
        let incoming_stream = request.into_inner();
        // A second Aquila stream would compete for the same work queue and make
        // delivery semantics unclear, so reject it at connection time.
        let outgoing_requests = Arc::clone(&self.stream_rx)
            .try_lock_owned()
            .map_err(|_| Status::already_exists("Aquila execution stream is already connected"))?;
        let (response_tx, response_rx) = mpsc::channel(EXECUTION_QUEUE_CAPACITY);

        tokio::spawn(Self::run_update_stream(
            client,
            incoming_stream,
            outgoing_requests,
            response_tx,
        ));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    // Sagittarius only needs an acknowledgment that the request was accepted into
    // the bridge. Actual delivery happens asynchronously through Aquila's stream.
    async fn push(
        &self,
        request: tonic::Request<ExecutionPushRequest>,
    ) -> Result<tonic::Response<ExecutionPushResponse>, tonic::Status> {
        let Some(test_execution) = Self::extract_test_execution(request) else {
            return Ok(Self::empty_push_response());
        };

        if let Err(err) = self.stream_tx.send(test_execution).await {
            let error = format!("{:?}", err);
            log::error!("{}", &error);
            return Err(Status::internal(error));
        }

        log::info!("Received test execution request, will proxy request to Aquila.");
        Ok(Self::empty_push_response())
    }
}
