use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::runtime_usage_service_client::RuntimeUsageServiceClient;
use tucana::sagittarius_rails::{RuntimeUsageRequest, RuntimeUsageResponse};

use super::retry::{RetryPolicy, retry};

pub struct SagittariusRailsRuntimeUsageServiceClient {
    inner: RuntimeUsageServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsRuntimeUsageServiceClient {
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
            inner: RuntimeUsageServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn update(
        &mut self,
        request: RuntimeUsageRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<RuntimeUsageResponse>, tonic::Status> {
        log::debug!(
            "Proxying a runtime usage request with {} usage(s).",
            request.runtime_usage.len()
        );
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
