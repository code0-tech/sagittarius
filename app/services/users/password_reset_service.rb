# frozen_string_literal: true

module Users
  class PasswordResetService
    include Sagittarius::Database::Transactional

    attr_reader :verification_code, :new_password

    def initialize(verification_code, new_password)
      @verification_code = verification_code
      @new_password = new_password
    end

    def execute
      user = User.find_by_token_for(:password_reset, verification_code)

      if user.nil?
        return ServiceResponse.error(message: 'Invalid or expired verification code',
                                     error_code: :invalid_verification_code)
      end

      transactional do |t|
        user.password = new_password
        unless user.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to reset password',
                                                       error_code: :failed_to_reset_password, details: user.errors)
        end

        AuditService.audit(
          :password_reset,
          author_id: user.id,
          entity: user,
          target: user,
          details: {}
        )

        ServiceResponse.success(message: 'Successfully reset password')
      end
    end
  end
end
