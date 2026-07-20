#![allow(dead_code)]

use crate::auth::{JwtClient, JwtVerifier, authentication_token};
use crate::client::module_service_client::SagittariusRailsModuleServiceClient;
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
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
    jwt_verifier: JwtVerifier,
    streams: Arc<Mutex<HashMap<i64, ModuleConfigurationSender>>>,
}

type ModuleConfigurationsStream = Pin<
    Box<dyn Stream<Item = Result<ModuleConfigurationResponse, tonic::Status>> + Send + 'static>,
>;

type ModuleConfigurationSender = mpsc::Sender<Result<ModuleConfigurationResponse, tonic::Status>>;

impl SagittariusModuleService {
    pub fn new(
        client: SagittariusRailsModuleServiceClient,
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

    async fn run_configurations_stream(
        runtime_id: i64,
        streams: Arc<Mutex<HashMap<i64, ModuleConfigurationSender>>>,
        outgoing_stream: ModuleConfigurationSender,
    ) {
        outgoing_stream.closed().await;
        streams.lock().await.remove(&runtime_id);
        log::info!(
            "Aquila module configuration stream closed for runtime {}.",
            runtime_id
        );
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
        streams: &Arc<Mutex<HashMap<i64, ModuleConfigurationSender>>>,
        runtime_id: i64,
        sender: ModuleConfigurationSender,
    ) -> Result<(), Status> {
        let mut streams = streams.lock().await;

        if streams.contains_key(&runtime_id) {
            return Err(Status::already_exists(
                "Aquila module configuration stream is already connected for runtime",
            ));
        }

        streams.insert(runtime_id, sender);
        Ok(())
    }

    async fn stream_for_runtime(
        &self,
        runtime_id: i64,
    ) -> Result<ModuleConfigurationSender, Status> {
        self.streams
            .lock()
            .await
            .get(&runtime_id)
            .cloned()
            .ok_or_else(|| {
                Status::unavailable(format!(
                    "no Aquila module configuration stream connected for runtime {runtime_id}"
                ))
            })
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

    fn extract_configuration_push(
        request: tonic::Request<ModuleConfigurationPushRequest>,
    ) -> (i64, Option<ModuleConfigurationResponse>) {
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
impl ModuleService for SagittariusModuleService {
    async fn update(
        &self,
        request: tonic::Request<ModuleUpdateRequest>,
    ) -> Result<tonic::Response<ModuleUpdateResponse>, tonic::Status> {
        let runtime_id =
            Self::verify_stream_runtime(&self.token_client, request.metadata()).await?;
        let authorization = self.jwt_client.authorization_for_runtime(runtime_id)?;
        let rails_request = Self::to_rails_update_request(request.into_inner());
        let rails_response = self
            .client
            .update(rails_request, authorization)
            .await?
            .into_inner();

        Ok(Response::new(Self::from_rails_update_response(
            rails_response,
        )))
    }

    type ConfigurationsStream = ModuleConfigurationsStream;

    async fn configurations(
        &self,
        request: tonic::Request<ModuleConfigurationRequest>,
    ) -> Result<tonic::Response<Self::ConfigurationsStream>, tonic::Status> {
        let metadata = request.metadata();
        let runtime_id = Self::verify_stream_runtime(&self.token_client, metadata).await?;
        let (response_tx, response_rx) = mpsc::channel(MODULE_CONFIGURATION_QUEUE_CAPACITY);

        Self::register_stream(&self.streams, runtime_id, response_tx.clone()).await?;

        log::info!(
            "Aquila module configuration stream connected for runtime {}.",
            runtime_id
        );

        tokio::spawn(Self::run_configurations_stream(
            runtime_id,
            Arc::clone(&self.streams),
            response_tx,
        ));

        Ok(Response::new(Box::pin(ReceiverStream::new(response_rx))))
    }

    async fn push(
        &self,
        request: tonic::Request<ModuleConfigurationPushRequest>,
    ) -> Result<tonic::Response<ModuleConfigurationPushResponse>, tonic::Status> {
        let runtime_id = self
            .jwt_verifier
            .runtime_id_from_metadata(request.metadata())?;
        let (request_runtime_id, Some(configuration)) = Self::extract_configuration_push(request)
        else {
            return Ok(Self::empty_push_response());
        };
        Self::ensure_matching_runtime(runtime_id, request_runtime_id)?;

        let stream = self.stream_for_runtime(runtime_id).await?;
        if Self::send_to_aquila_stream(&stream, configuration)
            .await
            .is_err()
        {
            self.streams.lock().await.remove(&runtime_id);
            return Err(Status::unavailable(format!(
                "Aquila module configuration stream closed for runtime {runtime_id}"
            )));
        }

        log::info!(
            "Received module configuration request, will proxy request to Aquila runtime {}.",
            runtime_id
        );
        Ok(Self::empty_push_response())
    }
}
