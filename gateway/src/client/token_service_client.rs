use tonic::codegen::StdError;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::token_service_client::TokenServiceClient;
use tucana::sagittarius_rails::{TokenVerifyRequest, TokenVerifyResponse};

pub struct SagittariusRailsTokenServiceClient {
    inner: TokenServiceClient<Channel>,
}

impl SagittariusRailsTokenServiceClient {
    pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
    where
        D: TryInto<Endpoint>,
        D::Error: Into<StdError>,
    {
        Ok(Self {
            inner: TokenServiceClient::connect(dst).await?,
        })
    }

    pub async fn update(
        &mut self,
        request: TokenVerifyRequest,
    ) -> Result<tonic::Response<TokenVerifyResponse>, tonic::Status> {
        self.inner.update(request).await
    }
}
