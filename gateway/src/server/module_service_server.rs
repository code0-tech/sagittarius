#![allow(dead_code)]

use crate::client::module_service_client::SagittariusRailsModuleServiceClient;
use std::pin::Pin;
use std::sync::Arc;

use tokio::sync::{Mutex, OwnedMutexGuard, mpsc};
use tonic::codegen::tokio_stream::Stream;
use tonic::codegen::tokio_stream::wrappers::ReceiverStream;
use tonic::metadata::MetadataMap;
use tonic::{Extensions, Response, Status};
use tucana::sagittarius_gateway::module_service_server::ModuleService;
use tucana::sagittarius_gateway::{
    ModuleConfigurationPushRequest, ModuleConfigurationPushResponse, ModuleConfigurationRequest,
    ModuleConfigurationResponse, ModuleUpdateRequest, ModuleUpdateResponse,
};
use tucana::sagittarius_rails::{
    ModuleUpdateRequest as RailsModuleUpdateRequest,
    ModuleUpdateResponse as RailsModuleUpdateResponse,
};

const MODULE_CONFIGURATION_QUEUE_CAPACITY: usize = 1024;

pub struct SagittariusModuleService {
    client: SagittariusRailsModuleServiceClient,
    // Push is unary while Aquila receives module configurations through a
    // long-lived stream, so the service needs a queue between those RPC shapes.
    stream_tx: mpsc::Sender<ModuleConfigurationResponse>,
    // There is one shared configuration queue for Aquila. Keeping the receiver
    // guarded here makes that single-consumer assumption explicit at the boundary.
    stream_rx: Arc<Mutex<mpsc::Receiver<ModuleConfigurationResponse>>>,
}

type ModuleConfigurationsStream = Pin<
    Box<dyn Stream<Item = Result<ModuleConfigurationResponse, tonic::Status>> + Send + 'static>,
>;

type ModuleConfigurationSender = mpsc::Sender<Result<ModuleConfigurationResponse, tonic::Status>>;

impl SagittariusModuleService {
    pub fn new(client: SagittariusRailsModuleServiceClient) -> Self {
        let (stream_tx, stream_rx) = mpsc::channel(MODULE_CONFIGURATION_QUEUE_CAPACITY);

        Self {
            client,
            stream_tx,
            stream_rx: Arc::new(Mutex::new(stream_rx)),
        }
    }

    async fn run_configurations_stream(
        mut queued_configurations: OwnedMutexGuard<mpsc::Receiver<ModuleConfigurationResponse>>,
        outgoing_stream: ModuleConfigurationSender,
    ) {
        while let Some(configuration) = queued_configurations.recv().await {
            if Self::send_to_aquila_stream(&outgoing_stream, configuration)
                .await
                .is_err()
            {
                log::info!("Aquila module configuration stream closed.");
                return;
            }
        }

        log::info!("Module configuration queue closed.");
    }

    async fn send_to_aquila_stream(
        outgoing_stream: &ModuleConfigurationSender,
        response: ModuleConfigurationResponse,
    ) -> Result<(), mpsc::error::SendError<Result<ModuleConfigurationResponse, tonic::Status>>>
    {
        outgoing_stream.send(Ok(response)).await
    }

    fn to_rails_update_request(request: ModuleUpdateRequest) -> RailsModuleUpdateRequest {
        RailsModuleUpdateRequest {
            modules: request.modules,
            available_defintition_soruces: Vec::new(),
        }
    }

    fn from_rails_update_response(response: RailsModuleUpdateResponse) -> ModuleUpdateResponse {
        ModuleUpdateResponse {
            success: response.success,
            error: response.error,
        }
    }

    fn empty_push_response() -> tonic::Response<ModuleConfigurationPushResponse> {
        Response::from_parts(
            MetadataMap::new(),
            ModuleConfigurationPushResponse {},
            Extensions::new(),
        )
    }

    fn extract_configuration_response(
        request: tonic::Request<ModuleConfigurationPushRequest>,
    ) -> Option<ModuleConfigurationResponse> {
        request.into_inner().response
    }
}

#[tonic::async_trait]
impl ModuleService for SagittariusModuleService {
    // Aquila sends module metadata as a unary update, while Rails owns the
    // backing state. This method stays as a direct proxy instead of using the
    // stream queue because there is no long-lived Aquila response involved.
    async fn update(
        &self,
        request: tonic::Request<ModuleUpdateRequest>,
    ) -> Result<tonic::Response<ModuleUpdateResponse>, tonic::Status> {
        let rails_request = Self::to_rails_update_request(request.into_inner());
        let rails_response = self.client.update(rails_request).await?.into_inner();

        Ok(Response::new(Self::from_rails_update_response(
            rails_response,
        )))
    }

    type ConfigurationsStream = ModuleConfigurationsStream;

    // Aquila owns the long-lived configuration stream, so this method starts the
    // bridge for module configuration pushes accepted by Sagittarius.
    async fn configurations(
        &self,
        _request: tonic::Request<ModuleConfigurationRequest>,
    ) -> Result<tonic::Response<Self::ConfigurationsStream>, tonic::Status> {
        // A second Aquila stream would compete for the same configuration queue
        // and make delivery semantics unclear, so reject it at connection time.
        let queued_configurations = Arc::clone(&self.stream_rx).try_lock_owned().map_err(|_| {
            Status::already_exists("Aquila module configuration stream is already connected")
        })?;
        let (response_tx, response_rx) = mpsc::channel(MODULE_CONFIGURATION_QUEUE_CAPACITY);

        tokio::spawn(Self::run_configurations_stream(
            queued_configurations,
            response_tx,
        ));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    // Sagittarius only needs an acknowledgment that the module configuration was
    // accepted into the bridge. Actual delivery happens through Aquila's stream.
    async fn push(
        &self,
        request: tonic::Request<ModuleConfigurationPushRequest>,
    ) -> Result<tonic::Response<ModuleConfigurationPushResponse>, tonic::Status> {
        let Some(configuration) = Self::extract_configuration_response(request) else {
            return Ok(Self::empty_push_response());
        };

        if let Err(err) = self.stream_tx.send(configuration).await {
            let error = format!("{:?}", err);
            log::error!("{}", &error);
            return Err(Status::internal(error));
        }

        log::info!("Received module configuration request, will proxy request to Aquila.");
        Ok(Self::empty_push_response())
    }
}
