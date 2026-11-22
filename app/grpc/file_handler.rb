# frozen_string_literal: true

class FileHandler < Tucana::Sagittarius::Rails::FileService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  # Called by the gateway when Aquila needs a URL to upload a file for an action. Only the signed URL is
  # returned; the bytes never travel over gRPC but via an HTTP PUT to the gateway ingress. The runtime may
  # only upload into projects it is assigned to; a missing project and one the runtime has no access to are
  # reported identically.
  def get_file_upload_url(request, _call)
    authentication = runtime_authentication
    project = NamespaceProject.find_by(id: request.project_id)

    expires_at = nil
    if request.has_expires_at?
      expires_at = Time.zone.at(Rational(request.expires_at, 1000))
      return upload_error_response('expires_at must be in the future') unless expires_at.future?
    end

    res = StorageObjects::PrepareUploadService.new(
      authentication,
      project: project,
      file_name: request.file_name,
      content_type: request.content_type,
      expires_at: expires_at,
      execution_identifier: request.execution_identifier
    ).execute

    return upload_error_response(res.message) if res.error?

    storage_object = res.payload
    signed = StorageObjects::SignedUrl.encode_upload(storage_object)

    Tucana::Sagittarius::Rails::GetFileUploadUrlResponse.new(
      id: storage_object.id,
      url: StorageObjects::SignedUrl.upload_url(signed.token),
      url_expires_at: epoch_ms(signed.expires_at)
    )
  end

  # Called by the gateway when Aquila needs to download a file a FILE value refers to. The runtime may only
  # fetch files of projects it is assigned to; a file that does not exist, belongs to another project or is
  # not accessible to the runtime is reported identically as not found.
  def get_file_download_url(request, _call)
    authentication = runtime_authentication

    storage_object = StorageObject.status_committed.find_by(id: request.id, project_id: request.project_id)

    unless storage_object.present? && !storage_object.expired? && storage_object.blob.attached? &&
           Ability.allowed?(authentication, :read_storage_object, storage_object)
      return download_error_response('Storage object not found')
    end

    signed = StorageObjects::SignedUrl.encode_download(storage_object)

    Tucana::Sagittarius::Rails::GetFileDownloadUrlResponse.new(
      url: StorageObjects::SignedUrl.download_url(signed.token),
      url_expires_at: epoch_ms(signed.expires_at),
      file: storage_object.to_grpc
    )
  end

  private

  def runtime_authentication
    runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])
    Sagittarius::Authentication.new(:runtime, runtime)
  end

  def epoch_ms(time)
    (time.to_r * 1000).to_i
  end

  def upload_error_response(message)
    Tucana::Sagittarius::Rails::GetFileUploadUrlResponse.new(
      error: Tucana::Shared::ServiceError.new(message: message)
    )
  end

  def download_error_response(message)
    Tucana::Sagittarius::Rails::GetFileDownloadUrlResponse.new(
      error: Tucana::Shared::ServiceError.new(message: message)
    )
  end
end
