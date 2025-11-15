# frozen_string_literal: true

module Users
  class EmailVerificationService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :verification_code

    def initialize(current_authentication, verification_code)
      @current_authentication = current_authentication
      @verification_code = verification_code
    end

    def execute
      user = User.find_by_token_for(:email_verification, verification_code)

      unless Ability.allowed?(current_authentication, :verify_email, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      transactional do |t|
        user.email_verified_at = Time.zone.now
        unless user.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to set email to verified',
                                                       error_code: :invalid_user, details: user.errors)
        end

        AuditService.audit(
          :email_verified,
          author_id: current_authentication.user.id,
          entity: user,
          target: user,
          details: {
            email: user.email,
          }
        )

        ServiceResponse.success(message: 'Successfully verified email', payload: user)
      end
    end
  end
end
