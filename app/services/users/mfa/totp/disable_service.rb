# frozen_string_literal: true

module Users
  module Mfa
    module Totp
      class DisableService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :current_user, :mfa

        def initialize(current_authentication, mfa)
          @current_authentication = current_authentication
          @current_user = current_authentication.user
          @mfa = mfa
        end

        def execute
          unless Ability.allowed?(current_authentication, :manage_mfa, current_user)
            return ServiceResponse.error(error_code: :missing_permission)
          end

          return ServiceResponse.error(error_code: :totp_secret_not_set) if current_user.totp_secret.nil?

          mfa_passed, mfa_type = current_user.validate_mfa!(mfa)

          return ServiceResponse.error(error_code: :mfa_failed) unless mfa_passed

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
              details: { type: mfa_type },
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
