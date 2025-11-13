# frozen_string_literal: true

module Files
  class UploadService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :object, :attachment, :attachment_name

    def initialize(current_authentication, object:, attachment:, attachment_name:)
      @current_authentication = current_authentication
      @object = object
      @attachment = attachment
      @attachment_name = attachment_name
    end

    def execute
      if object.nil? || current_authentication.nil? || attachment.nil? || attachment_name.nil?
        return ServiceResponse.error(message: 'Missing parameter', error_code: :missing_parameter)
      end

      unless Ability.allowed?(current_authentication, :"update_attachment_#{attachment_name}", object)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      # No other check because the permission will fail

      object.send(attachment_name).attach attachment

      unless object.save
        return ServiceResponse.error(message: 'Failed to save object', error_code: :invalid_attachment,
                                     details: object.errors)
      end

      AuditService.audit(
        :attachment_updated,
        author_id: current_authentication.user.id,
        entity: object,
        details: { attachment_name: attachment_name },
        target: object
      )

      ServiceResponse.success(message: 'Successfully attached', payload: object.send(attachment_name))
    end
  end
end
