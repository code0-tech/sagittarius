# frozen_string_literal: true

module Users
  module Mfa
    module Totp
      class GenerateSecretService
        attr_reader :current_authentication

        def initialize(current_authentication)
          @current_authentication = current_authentication
        end

        def execute
          unless Ability.allowed?(current_authentication, :manage_mfa, current_authentication.user)
            return ServiceResponse.error(error_code: :missing_permission)
          end

          unless current_authentication.user.totp_secret.nil?
            return ServiceResponse.error(error_code: :totp_secret_already_set)
          end

          totp_secret = ROTP::Base32.random

          ServiceResponse.success(message: 'TOTP secret generated',
                                  payload: Rails.application.message_verifier(:totp_secret)
                                                .generate(totp_secret))
        end
      end
    end
  end
end
