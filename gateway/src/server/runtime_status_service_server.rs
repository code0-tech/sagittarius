#![allow(dead_code)]

use std::sync::Arc;
use tokio::sync::Mutex;
use tucana::sagittarius_gateway::runtime_status_service_server::RuntimeStatusService;
use tucana::sagittarius_gateway::{RuntimeStatusUpdateRequest, RuntimeStatusUpdateResponse};

use crate::client::runtime_status_service_client::SagittariusRailsRuntimeStatusServiceClient;

pub struct SagittariusRuntimeStatusService {
    client: Arc<Mutex<SagittariusRailsRuntimeStatusServiceClient>>,
}

impl SagittariusRuntimeStatusService {
    pub fn new(client: SagittariusRailsRuntimeStatusServiceClient) -> Self {
        Self {
            client: Arc::new(Mutex::new(client)),
        }
    }
}

#[tonic::async_trait]
impl RuntimeStatusService for SagittariusRuntimeStatusService {
    async fn update(
        &self,
        request: tonic::Request<RuntimeStatusUpdateRequest>,
    ) -> Result<tonic::Response<RuntimeStatusUpdateResponse>, tonic::Status> {
        let status_request = convert_status_update_request(request);

        let response = {
            let mut client_lock = self.client.lock().await;
            client_lock.update(status_request).await
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
