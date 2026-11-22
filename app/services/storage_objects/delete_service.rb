# frozen_string_literal: true

module StorageObjects
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :storage_object

    def initialize(current_authentication, storage_object)
      @current_authentication = current_authentication
      @storage_object = storage_object
    end

    def execute
      if storage_object.nil?
        return ServiceResponse.error(message: 'Storage object not found', error_code: :storage_object_not_found)
      end

      # Without read access the file must look exactly like a non-existent one.
      unless Ability.allowed?(current_authentication, :read_storage_object, storage_object)
        return ServiceResponse.error(message: 'Storage object not found', error_code: :storage_object_not_found)
      end

      unless Ability.allowed?(current_authentication, :delete_storage_object, storage_object)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      transactional do
        project = storage_object.project
        file_name = storage_object.file_name
        storage_object.blob.purge if storage_object.blob.attached?
        storage_object.destroy!

        AuditService.audit(
          :storage_object_deleted,
          author_id: current_authentication.user.id,
          entity: storage_object,
          details: { file_name: file_name },
          target: project
        )

        ServiceResponse.success(message: 'Successfully deleted', payload: storage_object)
      end
    end
  end
end
