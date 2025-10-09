# frozen_string_literal: true

module Users
  class EmailVerificationSendService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user

    def initialize(current_authentication, user)
      @current_authentication = current_authentication
      @user = user
    end

    def execute
      unless Ability.allowed?(current_authentication, :send_verification_email, user)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        user.email_verified_at = nil
        unless user.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to set email to unverified',
                                                       payload: user.errors)
        end

        UserMailer.with(
          user: user,
          verification_code: user.generate_token_for(:email_verification)
        ).email_verification.deliver_later

        AuditService.audit(
          :email_verification_sent,
          author_id: current_authentication.user.id,
          entity: user,
          target: user,
          details: {
            email: user.email,
          }
        )

        ServiceResponse.success(message: 'Successfully sent email verification', payload: user)
      end
    end
  end
end
