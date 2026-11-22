# frozen_string_literal: true

module StorageObjects
  # Authorizes an upload and reserves it as a pending StorageObject. The file name, content type, expiry,
  # origin and execution identifier are fixed here; CompleteUploadService later fills in the bytes.
  #
  # Files are project-scoped (like flows). Users upload as `user_upload`, runtimes (authenticated through
  # the gRPC handler) as `execution_output`, and only into projects they are assigned to.
  class PrepareUploadService
    attr_reader :current_authentication, :project, :file_name, :content_type, :expires_at, :execution_identifier

    def initialize(current_authentication, project:, file_name:, content_type:, expires_at: nil,
                   execution_identifier: nil)
      @current_authentication = current_authentication
      @project = project
      @file_name = file_name
      @content_type = content_type
      @expires_at = expires_at
      @execution_identifier = execution_identifier.presence
    end

    def execute
      return ServiceResponse.error(message: 'Project not found', error_code: :project_not_found) if project.nil?

      # Without read access the project must look exactly like a non-existent one.
      unless Ability.allowed?(current_authentication, :read_storage_object, project)
        return ServiceResponse.error(message: 'Project not found', error_code: :project_not_found)
      end

      unless Ability.allowed?(current_authentication, :create_storage_object, project)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      storage_object = StorageObject.new(
        project: project,
        created_by: current_authentication.user,
        file_name: file_name,
        content_type: content_type.presence || 'application/octet-stream',
        byte_size: 0,
        origin: current_authentication.runtime? ? :execution_output : :user_upload,
        execution_identifier: execution_identifier,
        status: :pending,
        expires_at: expires_at
      )

      unless storage_object.save
        return ServiceResponse.error(message: 'Storage object is invalid',
                                     error_code: :invalid_storage_object, details: storage_object.errors)
      end

      ServiceResponse.success(message: 'Upload prepared', payload: storage_object)
    end
  end
end
