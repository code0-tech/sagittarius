# frozen_string_literal: true

class StorageObjectsController < ApplicationController
  include ActiveStorage::Streaming

  HTTP_STATUS_BY_ERROR_CODE = {
    project_not_found: :not_found,
    missing_permission: :forbidden,
    file_too_large: :content_too_large,
    quota_exceeded: :content_too_large,
    storage_object_not_found: :not_found,
  }.freeze

  # Terminated by the gateway and forwarded here (or called directly). Multipart contract:
  #   attachment            the file
  #   project_id            GlobalID or plain integer id of the target project
  #   execution_identifier  optional, set for files produced by a flow execution
  #   expires_at            optional, epoch milliseconds; without it the file lives forever
  # Authorization + persistence happen in the service. Users authenticate with `Session <token>`;
  # runtimes/actions upload with a signed URL via `upload_signed` instead.
  def upload
    authorization_token = request.headers['Authorization']
    current_authentication = find_authentication(authorization_token)

    return render_error('Unauthorized', 'unauthenticated', :unauthorized) if current_authentication.none?
    return render_error('Unauthorized', 'unauthenticated', :unauthorized) if current_authentication.invalid?

    return render_error('Missing parameter', 'missing_parameter', :bad_request) if upload_params[:project_id].blank?

    expires_at = parse_expires_at(upload_params[:expires_at])
    if expires_at == :invalid
      return render_error('expires_at must be epoch milliseconds', 'invalid_expires_at', :bad_request)
    end

    res = StorageObjects::CreateService.new(
      current_authentication,
      project: resolve_project(upload_params[:project_id]),
      attachment: upload_params[:attachment],
      expires_at: expires_at,
      execution_identifier: upload_params[:execution_identifier]
    ).execute

    if res.error?
      error_code = res.payload[:error_code]
      return render_error(res.message, error_code.to_s, HTTP_STATUS_BY_ERROR_CODE.fetch(error_code, :bad_request))
    end

    render json: storage_object_json(res.payload)
  end

  # `PUT /storage_objects/upload?signature=...`: the raw request body is the file content. The signed URL
  # was issued for exactly one pending storage object (see StorageObjects::PrepareUploadService), so there
  # is no Authorization header, and file name and content type are fixed already: the request's
  # Content-Type is ignored. An unknown, expired, already used or wrong-purpose token is a plain 404.
  def upload_signed
    storage_object = StorageObjects::SignedUrl.decode_upload(params[:signature])
    return render_error('Not found', 'storage_object_not_found', :not_found) if storage_object.nil?

    res = StorageObjects::CompleteUploadService.new(storage_object, io: request.body).execute

    if res.error?
      error_code = res.payload[:error_code]
      return render_error(res.message, error_code.to_s, HTTP_STATUS_BY_ERROR_CODE.fetch(error_code, :bad_request))
    end

    render json: storage_object_json(res.payload)
  end

  # Byte fetch authorized purely by the signed token; no session needed because
  # issuing the token already enforced project access.
  def download
    storage_object = StorageObjects::SignedUrl.decode_download(params[:signature])
    return head :not_found if storage_object.nil? || !storage_object.blob.attached?

    # The blob carries the file name and content type given at upload time.
    send_blob_stream storage_object.blob, disposition: 'attachment'
  end

  private

  def storage_object_json(storage_object)
    {
      id: storage_object.id,
      file_name: storage_object.file_name,
      content_type: storage_object.content_type,
      byte_size: storage_object.byte_size,
      checksum: storage_object.checksum,
      expires_at: storage_object.expires_at && (storage_object.expires_at.to_r * 1000).to_i,
    }
  end

  def render_error(message, error_code, status)
    render status: status, json: { message: message, error_code: error_code }
  end

  # Accepts epoch milliseconds (as an integer or digit string); returns nil when absent and
  # :invalid when malformed.
  def parse_expires_at(value)
    return nil if value.blank?
    return :invalid unless value.to_s.match?(/\A\d+\z/)

    Time.zone.at(Rational(value.to_i, 1000))
  rescue RangeError, ArgumentError
    :invalid
  end

  # The project id is either a plain integer (Aquila) or a GlobalID (GraphQL clients).
  def resolve_project(project_id)
    return nil if project_id.blank?
    return NamespaceProject.find_by(id: project_id.to_i) if project_id.to_s.match?(/\A\d+\z/)

    object = SagittariusSchema.object_from_id(project_id.to_s)
    object.is_a?(NamespaceProject) ? object : nil
  rescue StandardError
    nil
  end

  def upload_params
    params.permit(:attachment, :project_id, :execution_identifier, :expires_at)
  end
end
