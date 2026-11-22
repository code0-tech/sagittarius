use tonic::codegen::StdError;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tucana::sagittarius_rails::file_service_client::FileServiceClient;
use tucana::sagittarius_rails::{
    GetFileDownloadUrlRequest, GetFileDownloadUrlResponse, GetFileUploadUrlRequest,
    GetFileUploadUrlResponse,
};

use super::retry::{RetryPolicy, retry};

pub struct SagittariusRailsFileServiceClient {
    inner: FileServiceClient<Channel>,
    retry_policy: RetryPolicy,
}

impl SagittariusRailsFileServiceClient {
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
            inner: FileServiceClient::new(channel),
            retry_policy,
        })
    }

    pub async fn get_file_upload_url(
        &mut self,
        request: GetFileUploadUrlRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<GetFileUploadUrlResponse>, tonic::Status> {
        log::debug!(
            "Proxying a file upload url request for project {}.",
            request.project_id
        );
        retry(&self.retry_policy, || {
            let mut inner = self.inner.clone();
            let mut req = tonic::Request::new(request.clone());
            req.metadata_mut()
                .insert("authorization", authorization.clone());
            async move { inner.get_file_upload_url(req).await }
        })
        .await
    }

    pub async fn get_file_download_url(
        &mut self,
        request: GetFileDownloadUrlRequest,
        authorization: MetadataValue<tonic::metadata::Ascii>,
    ) -> Result<tonic::Response<GetFileDownloadUrlResponse>, tonic::Status> {
        log::debug!(
            "Proxying a file download url request for file {} in project {}.",
            request.id,
            request.project_id
        );
        retry(&self.retry_policy, || {
            let mut inner = self.inner.clone();
            let mut req = tonic::Request::new(request.clone());
            req.metadata_mut()
                .insert("authorization", authorization.clone());
            async move { inner.get_file_download_url(req).await }
        })
        .await
    }
}
