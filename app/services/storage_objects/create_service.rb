# frozen_string_literal: true

module StorageObjects
  # Stores an uploaded file in one step (multipart upload of a signed-in user): prepares the pending
  # storage object, then completes it with the received bytes. Rails is the system of record, so
  # authorization and persistence stay in one place. Actions use the same two steps split across a signed
  # URL (see PrepareUploadService and CompleteUploadService).
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :project, :attachment, :expires_at, :execution_identifier

    def initialize(current_authentication, project:, attachment:, expires_at: nil, execution_identifier: nil)
      @current_authentication = current_authentication
      @project = project
      @attachment = attachment
      @expires_at = expires_at
      @execution_identifier = execution_identifier.presence
    end

    def execute
      return ServiceResponse.error(message: 'Missing parameter', error_code: :missing_parameter) if attachment.nil?

      return ServiceResponse.error(message: 'Project not found', error_code: :project_not_found) if project.nil?

      unless uploaded_file?
        return ServiceResponse.error(message: 'Attachment must be an uploaded file', error_code: :invalid_attachment)
      end

      transactional do |t|
        prepared = PrepareUploadService.new(
          current_authentication,
          project: project,
          file_name: attachment.original_filename,
          content_type: attachment.content_type,
          expires_at: expires_at,
          execution_identifier: execution_identifier
        ).execute
        next prepared if prepared.error?

        completed = CompleteUploadService.new(prepared.payload, io: attachment.tempfile).execute
        t.rollback_and_return!(completed) if completed.error?

        completed
      end
    end

    private

    def uploaded_file?
      return true if attachment.is_a?(ActionDispatch::Http::UploadedFile)

      # only loaded in test environments, where specs hand in fixture uploads directly
      defined?(Rack::Test::UploadedFile) && attachment.is_a?(Rack::Test::UploadedFile)
    end
  end
end
