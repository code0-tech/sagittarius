use std::pin::Pin;

use tokio_stream::Stream;
use tonic::{Request, Response, Status};
use tonic_health::pb::health_check_response::ServingStatus;
use tonic_health::pb::health_server::Health;
use tonic_health::pb::{HealthCheckRequest, HealthCheckResponse};

#[derive(Debug, Default)]
pub struct GatewayHealthService;

#[tonic::async_trait]
impl Health for GatewayHealthService {
    async fn check(
        &self,
        request: Request<HealthCheckRequest>,
    ) -> Result<Response<HealthCheckResponse>, Status> {
        let service = request.into_inner().service.to_lowercase();
        match service.as_str() {
            "liveness" | "readiness" => Ok(Response::new(HealthCheckResponse {
                status: ServingStatus::Serving as i32,
            })),
            _ => Err(Status::invalid_argument(
                "Unknown service. Only `liveness` and `readiness` are supported.",
            )),
        }
    }

    type WatchStream =
        Pin<Box<dyn Stream<Item = Result<HealthCheckResponse, Status>> + Send + 'static>>;

    async fn watch(
        &self,
        _request: Request<HealthCheckRequest>,
    ) -> Result<Response<Self::WatchStream>, Status> {
        Err(Status::unimplemented("Watch is not implemented"))
    }
}
