use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::execution_service_client::ExecutionServiceClient;
use tucana::sagittarius_rails::{ExecutionRequest, ExecutionResponse};

#[derive(Clone)]
pub struct SagittariusRailsExecutionServiceClient {
    inner: ExecutionServiceClient<Channel>,
}

impl SagittariusRailsExecutionServiceClient {
    pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        Ok(Self {
            inner: ExecutionServiceClient::connect(dst).await?,
        })
    }

    pub async fn update(
        &self,
        request: ExecutionRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<ExecutionResponse>, tonic::Status> {
        log::debug!("Proxying a execution response.");
        let mut request = tonic::Request::new(request);
        request
            .metadata_mut()
            .insert("authorization", authorization);
        self.inner.clone().update(request).await
    }
}
