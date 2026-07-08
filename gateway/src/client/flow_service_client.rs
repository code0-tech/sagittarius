use tonic::codegen::StdError;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::flow_service_client::FlowServiceClient;
use tucana::sagittarius_rails::{FlowLogonRequest, FlowResponse};

#[derive(Clone)]
pub struct SagittariusRailsFlowServiceClient {
    inner: FlowServiceClient<Channel>,
}

impl SagittariusRailsFlowServiceClient {
    pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        Ok(Self {
            inner: FlowServiceClient::connect(dst).await?,
        })
    }

    pub async fn update(
        &self,
        request: FlowLogonRequest,
    ) -> Result<tonic::Response<FlowResponse>, tonic::Status> {
        log::debug!("Proxying a execution flow logon request.");
        self.inner.clone().update(request).await
    }
}
