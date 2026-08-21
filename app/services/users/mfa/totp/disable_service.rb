# frozen_string_literal: true

module Users
  module Mfa
    module Totp
      class DisableService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :current_user, :current_totp

        def initialize(current_authentication, current_totp)
          @current_authentication = current_authentication
          @current_user = current_authentication.user
          @current_totp = current_totp
        end

        def execute
          unless Ability.allowed?(current_authentication, :manage_mfa, current_user)
            return ServiceResponse.error(error_code: :missing_permission)
          end

          return ServiceResponse.error(error_code: :totp_secret_not_set) if current_user.totp_secret.nil?

          totp = ROTP::TOTP.new(current_user.totp_secret)

          return ServiceResponse.error(error_code: :wrong_totp) unless totp.verify(current_totp)

          transactional do
            current_user.totp_secret = nil
            unless current_user.save
              return ServiceResponse.error(message: 'Error while saving user', error_code: :invalid_user,
                                           details: current_user.errors)
            end

            AuditService.audit(
              :mfa_disabled,
              author_id: current_user.id,
              entity: current_user,
              details: { type: :totp },
              target: current_user
            )

            ServiceResponse.success(message: 'TOTP disabled',
                                    payload: current_user)
          end
        end
      end
    end
  end
end
