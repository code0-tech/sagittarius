use tonic::codegen::StdError;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::token_service_client::TokenServiceClient;
use tucana::sagittarius_rails::token_verify_response::Data;
use tucana::sagittarius_rails::{TokenVerifyRequest, TokenVerifyResponse};

pub enum RuntimeVerificationStatus {
    Verified { runtime_id: i64 },
    Unverified,
}

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

    async fn update(
        &mut self,
        request: TokenVerifyRequest,
    ) -> Result<tonic::Response<TokenVerifyResponse>, tonic::Status> {
        self.inner.verify(request).await
    }

    pub async fn validate_token(&mut self, token: String) -> RuntimeVerificationStatus {
        let response = self.update(TokenVerifyRequest { token }).await;

        let status_response = match response {
            Ok(res) => res,
            Err(_) => return RuntimeVerificationStatus::Unverified,
        };

        match status_response.into_inner().data {
            Some(status) => match status {
                Data::Verified(verified_runtime) => RuntimeVerificationStatus::Verified {
                    runtime_id: verified_runtime.runtime_id,
                },
                Data::Unverified(_) => RuntimeVerificationStatus::Unverified,
            },
            None => RuntimeVerificationStatus::Unverified,
        }
    }
}
