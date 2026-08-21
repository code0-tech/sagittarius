use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::flow_service_client::FlowServiceClient;
use tucana::sagittarius_rails::{FlowLogonRequest, FlowResponse};

use super::retry::{RetryPolicy, retry};

#[derive(Clone)]
pub struct SagittariusRailsFlowServiceClient {
    inner: FlowServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsFlowServiceClient {
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
            inner: FlowServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn update(
        &self,
        request: FlowLogonRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<FlowResponse>, tonic::Status> {
        log::debug!("Proxying a execution flow logon request.");
        retry(&self.retry_policy, || {
            let mut inner = self.inner.clone();
            let mut req = tonic::Request::new(request);
            req.metadata_mut()
                .insert("authorization", authorization.clone());
            async move { inner.update(req).await }
        })
        .await
    }
}
