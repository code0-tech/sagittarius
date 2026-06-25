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
        namespace = user.namespace
        audit_author_id = user == current_authentication.user ? User.ghost.id : current_authentication.user.id

        user.destroy

        if user.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete user',
            error_code: :invalid_user,
            details: user.errors
          )
        end

        namespace&.delete

        if namespace.present? && namespace.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete user namespace',
            error_code: :invalid_user,
            details: namespace.errors
          )
        end

        AuditService.audit(
          :user_deleted,
          author_id: audit_author_id,
          entity: user,
          target: AuditEvent::GLOBAL_TARGET,
          details: {}
        )

        ServiceResponse.success(message: 'Deleted user', payload: user)
      end
    end
  end
end
