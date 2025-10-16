# frozen_string_literal: true

module Users
  class PasswordResetRequestService
    include Sagittarius::Database::Transactional

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def execute
      if user.nil?
        return ServiceResponse.success(message: 'Sent password reset email') # Do not reveal whether user exists
      end

      UserMailer.with(
        user: user,
        verification_code: user.generate_token_for(:password_reset)
      ).password_reset.deliver_later

      AuditService.audit(
        :password_reset_requested,
        author_id: user.id,
        entity: user,
        target: user,
        details: {
          email: user.email,
        }
      )

      ServiceResponse.success(message: 'Sent password reset email')
    end
  end
end
