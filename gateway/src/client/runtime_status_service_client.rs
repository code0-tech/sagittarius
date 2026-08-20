use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::runtime_status_service_client::RuntimeStatusServiceClient;
use tucana::sagittarius_rails::{RuntimeStatusUpdateRequest, RuntimeStatusUpdateResponse};

use super::retry::{RetryPolicy, retry};

pub struct SagittariusRailsRuntimeStatusServiceClient {
    inner: RuntimeStatusServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsRuntimeStatusServiceClient {
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
            inner: RuntimeStatusServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn update(
        &mut self,
        request: RuntimeStatusUpdateRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<RuntimeStatusUpdateResponse>, tonic::Status> {
        log::debug!("Proxying a status update request.");
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
