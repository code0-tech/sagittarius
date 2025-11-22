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

      transactional do |t|
        user.delete

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
  end
end
