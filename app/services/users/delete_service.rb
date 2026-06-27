# frozen_string_literal: true

module Users
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user

    def initialize(current_authentication, user)
      @current_authentication = current_authentication
      @user = user
    end

    def execute
      unless Ability.allowed?(current_authentication, :delete_user, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      deletion_error = validate_deletion
      return deletion_error if deletion_error

      transactional do |t|
        user.destroy

        if user.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete user',
            error_code: :invalid_user,
            details: user.errors
          )
        end

        AuditService.audit(
          :user_deleted,
          author_id: current_authentication.user.id,
          entity: user,
          target: AuditEvent::GLOBAL_TARGET,
          details: {}
        )

        ServiceResponse.success(message: 'Deleted user', payload: user)
      end
    end

    def deletion_restriction
      :last_administrator if user.admin? && !User.where.not(id: user.id).exists?(admin: true)
    end

    private

    def validate_deletion
      return unless deletion_restriction == :last_administrator

      ServiceResponse.error(
        message: 'The last instance administrator cannot be deleted',
        error_code: :cannot_delete_last_administrator
      )
    end
  end
end

Users::DeleteService.prepend_extensions
