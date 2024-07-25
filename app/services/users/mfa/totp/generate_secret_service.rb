# frozen_string_literal: true

module Users
  module Mfa
    module Totp
      class GenerateSecretService
        attr_reader :current_user

        def initialize(current_user)
          @current_user = current_user
        end

        def execute
          unless Ability.allowed?(@current_user, :manage_mfa, @current_user)
            return ServiceResponse.error(payload: :missing_permission)
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
