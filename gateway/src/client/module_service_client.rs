use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::module_service_client::ModuleServiceClient;
use tucana::sagittarius_rails::{ModuleUpdateRequest, ModuleUpdateResponse};

use super::retry::{RetryPolicy, retry};

#[derive(Clone)]
pub struct SagittariusRailsModuleServiceClient {
    inner: ModuleServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsModuleServiceClient {
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
            inner: ModuleServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn update(
        &self,
        request: ModuleUpdateRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<ModuleUpdateResponse>, tonic::Status> {
        log::debug!("Proxying a module update request.");
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
