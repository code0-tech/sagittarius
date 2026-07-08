#![allow(dead_code)]

use tucana::sagittarius_gateway::runtime_status_service_server::RuntimeStatusService;
use tucana::sagittarius_gateway::{RuntimeStatusUpdateRequest, RuntimeStatusUpdateResponse};

pub struct SagittariusRuntimeStatusService {}

#[tonic::async_trait]
impl RuntimeStatusService for SagittariusRuntimeStatusService {
    async fn update(
        &self,
        _request: tonic::Request<RuntimeStatusUpdateRequest>,
    ) -> Result<tonic::Response<RuntimeStatusUpdateResponse>, tonic::Status> {
        Ok(tonic::Response::new(RuntimeStatusUpdateResponse {
            success: true,
            error: None,
        }))
    }
}
