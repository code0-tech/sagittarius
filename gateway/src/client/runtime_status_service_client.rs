use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::runtime_status_service_client::RuntimeStatusServiceClient;
use tucana::sagittarius_rails::{RuntimeStatusUpdateRequest, RuntimeStatusUpdateResponse};

pub struct SagittariusRailsRuntimeStatusServiceClient {
    inner: RuntimeStatusServiceClient<Channel>,
}

impl SagittariusRailsRuntimeStatusServiceClient {
    pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        Ok(Self {
            inner: RuntimeStatusServiceClient::connect(dst).await?,
        })
    }

    pub async fn update(
        &mut self,
        request: RuntimeStatusUpdateRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<RuntimeStatusUpdateResponse>, tonic::Status> {
        log::debug!("Proxying a status update request.");
        let mut request = tonic::Request::new(request);
        request
            .metadata_mut()
            .insert("authorization", authorization);
        self.inner.update(request).await
    }
}
