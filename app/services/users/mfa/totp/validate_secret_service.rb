# frozen_string_literal: true

module Users
  module Mfa
    module Totp
      class ValidateSecretService
        include Sagittarius::Database::Transactional

        attr_reader :current_user, :secret, :current_totp

        def initialize(current_user, secret, current_totp)
          @current_user = current_user
          @secret = secret
          @current_totp = current_totp
        end

        def execute
          unless Ability.allowed?(@current_user, :manage_mfa, @current_user)
            return ServiceResponse.error(payload: :missing_permission)
          end

          totp_secret = Rails.application.message_verifier(:totp_secret).verified(secret)

          return ServiceResponse.error(payload: :invalid_totp_secret) if totp_secret.nil?

          totp = ROTP::TOTP.new(totp_secret)

          return ServiceResponse.error(payload: :wrong_totp) unless totp.verify(current_totp)

          transactional do
            @current_user.totp_secret = totp_secret
            unless @current_user.save
              return ServiceResponse.error(message: 'Error while saving user', payload: @current_user.errors)
            end

            AuditService.audit(
              :mfa_enabled,
              author_id: @current_user.id,
              entity: @current_user,
              details: { type: :totp },
              target: @current_user
            )

            ServiceResponse.success(message: 'TOTP secret validated', payload: @current_user)
          end
        end
      end
    end
  end
end
