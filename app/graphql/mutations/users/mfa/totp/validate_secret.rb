# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module Totp
        class ValidateSecret < BaseMutation
          description 'Generates an encrypted totp secret'

          field :user, ::Types::UserType, null: true, description: 'The modified user'

          argument :current_totp, String, required: true,
                                          description: 'The current totp at the time to verify the mfa
                                                        authentication device'
          argument :secret, String, required: true, description: 'The signed secret from the generation'

          def resolve(secret:, current_totp:)
            ::Users::Mfa::Totp::ValidateSecretService.new(current_user, secret,
                                                          current_totp).execute.to_mutation_response(success_key: :user)
          end
        end
      end
    end
  end
end
