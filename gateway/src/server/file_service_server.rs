#![allow(dead_code)]

use std::sync::Arc;
use tokio::sync::Mutex;
use tucana::sagittarius_gateway::file_service_server::FileService;
use tucana::sagittarius_gateway::{
    GetFileDownloadUrlRequest, GetFileDownloadUrlResponse, GetFileUploadUrlRequest,
    GetFileUploadUrlResponse,
};

use crate::auth::{JwtClient, authentication_token};
use crate::client::file_service_client::SagittariusRailsFileServiceClient;
use crate::client::token_service_client::{
    RuntimeVerificationStatus, SagittariusRailsTokenServiceClient,
};

/// Resolves the short-lived upload/download URLs of stored files for Aquila, on behalf of the
/// runtime the Aquila token belongs to. Sagittarius Rails decides whether that runtime
/// may access the file.
pub struct SagittariusFileService {
    client: Arc<Mutex<SagittariusRailsFileServiceClient>>,
    token_client: SagittariusRailsTokenServiceClient,
    jwt_client: JwtClient,
}

impl SagittariusFileService {
    pub fn new(
        client: SagittariusRailsFileServiceClient,
        token_client: SagittariusRailsTokenServiceClient,
        jwt_client: JwtClient,
    ) -> Self {
        Self {
            client: Arc::new(Mutex::new(client)),
            token_client,
            jwt_client,
        }
    }

    async fn authenticate(
        &self,
        metadata: &tonic::metadata::MetadataMap,
    ) -> Result<tonic::metadata::MetadataValue<tonic::metadata::Ascii>, tonic::Status> {
        let token = authentication_token(metadata)?;
        let runtime_id = match self.token_client.validate_token(token).await {
            RuntimeVerificationStatus::Verified { runtime_id } => runtime_id,
            RuntimeVerificationStatus::Unverified => {
                return Err(tonic::Status::unauthenticated(
                    "invalid Aquila authentication token",
                ));
            }
        };

        self.jwt_client.authorization_for_runtime(runtime_id)
    }
}

#[tonic::async_trait]
impl FileService for SagittariusFileService {
    async fn get_file_upload_url(
        &self,
        request: tonic::Request<GetFileUploadUrlRequest>,
    ) -> Result<tonic::Response<GetFileUploadUrlResponse>, tonic::Status> {
        let authorization = self.authenticate(request.metadata()).await?;
        let rails_request = convert_upload_request(request);

        let response = {
            let mut client_lock = self.client.lock().await;
            client_lock
                .get_file_upload_url(rails_request, authorization)
                .await
        }?;

        let response = response.into_inner();

        Ok(tonic::Response::new(GetFileUploadUrlResponse {
            id: response.id,
            url: response.url,
            url_expires_at: response.url_expires_at,
            error: response.error,
        }))
    }

    async fn get_file_download_url(
        &self,
        request: tonic::Request<GetFileDownloadUrlRequest>,
    ) -> Result<tonic::Response<GetFileDownloadUrlResponse>, tonic::Status> {
        let authorization = self.authenticate(request.metadata()).await?;
        let rails_request = convert_request(request);

        let response = {
            let mut client_lock = self.client.lock().await;
            client_lock
                .get_file_download_url(rails_request, authorization)
                .await
        }?;

        let response = response.into_inner();

        Ok(tonic::Response::new(GetFileDownloadUrlResponse {
            url: response.url,
            url_expires_at: response.url_expires_at,
            file: response.file,
            error: response.error,
        }))
    }
}

fn convert_upload_request(
    request: tonic::Request<GetFileUploadUrlRequest>,
) -> tucana::sagittarius_rails::GetFileUploadUrlRequest {
    let request = request.into_inner();

    tucana::sagittarius_rails::GetFileUploadUrlRequest {
        file_name: request.file_name,
        content_type: request.content_type,
        expires_at: request.expires_at,
        project_id: request.project_id,
        execution_identifier: request.execution_identifier,
    }
}

fn convert_request(
    request: tonic::Request<GetFileDownloadUrlRequest>,
) -> tucana::sagittarius_rails::GetFileDownloadUrlRequest {
    let request = request.into_inner();

    tucana::sagittarius_rails::GetFileDownloadUrlRequest {
        id: request.id,
        project_id: request.project_id,
        execution_identifier: request.execution_identifier,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn converts_the_upload_request_field_for_field() {
        let converted = convert_upload_request(tonic::Request::new(GetFileUploadUrlRequest {
            file_name: "out.csv".into(),
            content_type: "text/csv".into(),
            expires_at: Some(1_700_000_000_000),
            project_id: 3,
            execution_identifier: "exec-1".into(),
        }));

        assert_eq!(converted.file_name, "out.csv");
        assert_eq!(converted.content_type, "text/csv");
        assert_eq!(converted.expires_at, Some(1_700_000_000_000));
        assert_eq!(converted.project_id, 3);
        assert_eq!(converted.execution_identifier, "exec-1");
    }

    #[test]
    fn converts_the_download_request_field_for_field() {
        let converted = convert_request(tonic::Request::new(GetFileDownloadUrlRequest {
            id: 7,
            project_id: 3,
            execution_identifier: "exec-1".into(),
        }));

        assert_eq!(converted.id, 7);
        assert_eq!(converted.project_id, 3);
        assert_eq!(converted.execution_identifier, "exec-1");
    }
}
