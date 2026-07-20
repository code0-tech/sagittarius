use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::module_service_client::ModuleServiceClient;
use tucana::sagittarius_rails::{ModuleUpdateRequest, ModuleUpdateResponse};

#[derive(Clone)]
pub struct SagittariusRailsModuleServiceClient {
    inner: ModuleServiceClient<Channel>,
}

impl SagittariusRailsModuleServiceClient {
    pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        Ok(Self {
            inner: ModuleServiceClient::connect(dst).await?,
        })
    }

    pub async fn update(
        &self,
        request: ModuleUpdateRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<ModuleUpdateResponse>, tonic::Status> {
        log::debug!("Proxying a module update request.");
        let mut request = tonic::Request::new(request);
        request
            .metadata_mut()
            .insert("authorization", authorization);
        self.inner.clone().update(request).await
    }
}
