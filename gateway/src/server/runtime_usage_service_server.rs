#![allow(dead_code)]

use std::sync::Arc;
use tokio::sync::Mutex;
use tucana::sagittarius_gateway::runtime_usage_service_server::RuntimeUsageService;
use tucana::sagittarius_gateway::{RuntimeUsageRequest, RuntimeUsageResponse};

use crate::auth::{JwtClient, authentication_token};
use crate::client::runtime_usage_service_client::SagittariusRailsRuntimeUsageServiceClient;
use crate::client::token_service_client::{
    RuntimeVerificationStatus, SagittariusRailsTokenServiceClient,
};

/// Receives the runtime usage Aquila collects from its runtimes and forwards
/// it to Sagittarius Rails on behalf of the runtime the Aquila token belongs
/// to.
pub struct SagittariusRuntimeUsageService {
    client: Arc<Mutex<SagittariusRailsRuntimeUsageServiceClient>>,
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
}

impl SagittariusRuntimeUsageService {
    pub fn new(
        client: SagittariusRailsRuntimeUsageServiceClient,
        token_client: SagittariusRailsTokenServiceClient,
        jwt_client: JwtClient,
    ) -> Self {
        Self {
            client: Arc::new(Mutex::new(client)),
            token_client,
            jwt_client,
        }
    }

    async fn authenticate(
        &self,
        metadata: &tonic::metadata::MetadataMap,
    ) -> Result<tonic::metadata::MetadataValue<tonic::metadata::Ascii>, tonic::Status> {
        let token = authentication_token(metadata)?;
        let runtime_id = match self.token_client.validate_token(token).await {
            RuntimeVerificationStatus::Verified { runtime_id } => runtime_id,
            RuntimeVerificationStatus::Unverified => {
                return Err(tonic::Status::unauthenticated(
                    "invalid Aquila authentication token",
                ));
            }
        };

        self.jwt_client.authorization_for_runtime(runtime_id)
    }
}

#[tonic::async_trait]
impl RuntimeUsageService for SagittariusRuntimeUsageService {
    async fn update(
        &self,
        request: tonic::Request<RuntimeUsageRequest>,
    ) -> Result<tonic::Response<RuntimeUsageResponse>, tonic::Status> {
        let authorization = self.authenticate(request.metadata()).await?;
        let usage_request = convert_usage_request(request);

        let response = {
            let mut client_lock = self.client.lock().await;
            client_lock.update(usage_request, authorization).await
        }?;

        let usage_response = response.into_inner();

        Ok(tonic::Response::new(RuntimeUsageResponse {
            success: usage_response.success,
            error: usage_response.error,
        }))
    }
}

fn convert_usage_request(
    request: tonic::Request<RuntimeUsageRequest>,
) -> tucana::sagittarius_rails::RuntimeUsageRequest {
    tucana::sagittarius_rails::RuntimeUsageRequest {
        runtime_usage: request.into_inner().runtime_usage,
    }
}
