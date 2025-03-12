# frozen_string_literal: true

class FilesController < ApplicationController
  def upload
    authorization_token = request.headers['Authorization']

    current_authentication = find_authentication(authorization_token)

    return head :unauthorized if authorization_token.present? == current_authentication.none?
    return head :unauthorized if current_authentication.invalid?
    return head :unauthorized if current_authentication.type == :none

    object = SagittariusSchema.object_from_id upload_params[:id]
    attachment = upload_params[:attachment]
    attachment_name = upload_params[:attachment_name]

    res = Files::UploadService.new(current_authentication, object: object, attachment: attachment,
                                                           attachment_name: attachment_name).execute

    return render status: :bad_request, json: { message: res.message } if res.error?

    attached_attachment = object.send(attachment_name)
    return render json: { path: nil } if attached_attachment.blob.nil?

    render json: { path: Rails.application.routes.url_helpers.rails_storage_proxy_path(attached_attachment) }
  end

  private

  def upload_params
    params.permit(:attachment, :attachment_name, :id)
  end
end
