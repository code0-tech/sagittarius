use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::execution_service_client::ExecutionServiceClient;
use tucana::sagittarius_rails::{ExecutionRequest, ExecutionResponse};

use super::retry::{RetryPolicy, retry};

#[derive(Clone)]
pub struct SagittariusRailsExecutionServiceClient {
    inner: ExecutionServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsExecutionServiceClient {
    pub async fn connect<D>(
        dst: D,
        retry_policy: RetryPolicy,
    ) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        let channel = Endpoint::new(dst)?.connect_lazy();
        Ok(Self {
            inner: ExecutionServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn update(
        &self,
        request: ExecutionRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<ExecutionResponse>, tonic::Status> {
        log::debug!("Proxying a execution response.");
        retry(&self.retry_policy, || {
            let mut inner = self.inner.clone();
            let mut req = tonic::Request::new(request.clone());
            req.metadata_mut()
                .insert("authorization", authorization.clone());
            async move { inner.update(req).await }
        })
        .await
    }
}
