# frozen_string_literal: true

module Users
  class PasswordResetRequestService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user

    def initialize(current_authentication, user)
      @current_authentication = current_authentication
      @user = user
    end

    def execute
      unless Ability.allowed?(current_authentication, :request_password_reset, user)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      UserMailer.with(
        user: user,
        verification_code: user.generate_token_for(:password_reset)
      ).password_reset.deliver_later

      AuditService.audit(
        :password_reset_requested,
        author_id: current_authentication.user.id,
        entity: user,
        target: user,
        details: {}
      )

      ServiceResponse.success(message: 'Successfully sent password reset request', payload: user)
    end
  end
end
