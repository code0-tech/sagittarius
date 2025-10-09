# frozen_string_literal: true

module Users
  class PasswordResetService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :verification_code, :mfa, :new_password

    def initialize(current_authentication, verification_code, mfa, new_password)
      @current_authentication = current_authentication
      @verification_code = verification_code
      @mfa = mfa
      @new_password = new_password
    end

    def execute
      user = User.find_by_token_for(:password_reset, verification_code)

      unless Ability.allowed?(current_authentication, :reset_password, user)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        if mfa.nil?
          return ServiceResponse.error(
            message: "MFA required for password reset",
            payload: :mfa_required
          )
        end

        mfa_passed, mfa_type = user.validate_mfa!(mfa)

        unless mfa_passed
          t.rollback_and_return! ServiceResponse.error(message: 'MFA failed',
                                                       payload: :mfa_failed)
        end

        user.password = new_password
        unless user.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to reset password', payload: user.errors)
        end

        AuditService.audit(
          :password_reset,
          author_id: current_authentication.user.id,
          entity: user,
          target: user,
          details: {
            mfa_type: mfa_type,
          }
        )

        ServiceResponse.success(message: 'Successfully reset password', payload: user)
      end
    end
  end
end
