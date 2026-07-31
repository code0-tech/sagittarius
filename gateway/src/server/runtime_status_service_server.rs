#![allow(dead_code)]

use std::sync::Arc;
use tokio::sync::Mutex;
use tucana::sagittarius_gateway::runtime_status_service_server::RuntimeStatusService;
use tucana::sagittarius_gateway::{RuntimeStatusUpdateRequest, RuntimeStatusUpdateResponse};

use crate::auth::{JwtClient, authentication_token};
use crate::client::runtime_status_service_client::SagittariusRailsRuntimeStatusServiceClient;
use crate::client::token_service_client::{
    RuntimeVerificationStatus, SagittariusRailsTokenServiceClient,
};

pub struct SagittariusRuntimeStatusService {
    client: Arc<Mutex<SagittariusRailsRuntimeStatusServiceClient>>,
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
}

impl SagittariusRuntimeStatusService {
    pub fn new(
        client: SagittariusRailsRuntimeStatusServiceClient,
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
impl RuntimeStatusService for SagittariusRuntimeStatusService {
    async fn update(
        &self,
        request: tonic::Request<RuntimeStatusUpdateRequest>,
    ) -> Result<tonic::Response<RuntimeStatusUpdateResponse>, tonic::Status> {
        let authorization = self.authenticate(request.metadata()).await?;
        let status_request = convert_status_update_request(request);

        let response = {
            let mut client_lock = self.client.lock().await;
            client_lock.update(status_request, authorization).await
        }?;

        let status_response = response.into_inner();

        Ok(tonic::Response::new(RuntimeStatusUpdateResponse {
            success: status_response.success,
            error: status_response.error,
        }))
    }
}

fn convert_status_update_request(
    request: tonic::Request<RuntimeStatusUpdateRequest>,
) -> tucana::sagittarius_rails::RuntimeStatusUpdateRequest {
    let status_request = request.into_inner();

    tucana::sagittarius_rails::RuntimeStatusUpdateRequest {
        status: status_request.status,
    }
}
