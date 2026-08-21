use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::token_service_client::TokenServiceClient;
use tucana::sagittarius_rails::token_verify_response::Data;
use tucana::sagittarius_rails::{TokenVerifyRequest, TokenVerifyResponse};

use super::retry::{RetryPolicy, retry};

pub enum RuntimeVerificationStatus {
    Verified { runtime_id: i64 },
    Unverified,
}

#[derive(Clone)]
pub struct SagittariusRailsTokenServiceClient {
    inner: TokenServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsTokenServiceClient {
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
            inner: TokenServiceClient::new(channel),
            retry_policy,
        })
    }

    async fn verify(
        &self,
        token: String,
    ) -> Result<tonic::Response<TokenVerifyResponse>, tonic::Status> {
        let authorization: MetadataValue<tonic::metadata::Ascii> = token
            .parse()
            .map_err(|_| tonic::Status::unauthenticated("invalid Aquila authentication token"))?;
        retry(&self.retry_policy, || {
            let mut inner = self.inner.clone();
            let mut req = tonic::Request::new(TokenVerifyRequest {
                token: token.clone(),
            });
            req.metadata_mut()
                .insert("authorization", authorization.clone());
            async move { inner.verify(req).await }
        })
        .await
    }

    pub async fn validate_token(&self, token: String) -> RuntimeVerificationStatus {
        let response = self.verify(token).await;

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
