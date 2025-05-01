# frozen_string_literal: true

module Users
  class ChangePasswordService
    include Sagittarius::Database::Transactional
    include Code0::ZeroTrack::Loggable

    attr_reader :current_authentication, :new_password

    def initialize(current_authentication, new_password)
      @current_authentication = current_authentication
      @new_password = new_password
    end

    def execute
      unless Ability.allowed?(current_authentication, :change_password, current_authentication.user)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        success = current_authentication.user.update({ password: new_password })
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update user´s password',
            payload: current_authentication.user.errors
          )
        end

        AuditService.audit(
          :user_password_changed,
          author_id: current_authentication.user.id,
          entity: current_authentication.user,
          target: current_authentication.user,
          details: {}
        )

        ServiceResponse.success(message: 'Updated user´s password', payload: current_authentication.user)
      end
    end
  end
end
