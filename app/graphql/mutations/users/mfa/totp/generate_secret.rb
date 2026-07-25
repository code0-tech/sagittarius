# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module Totp
        class GenerateSecret < BaseMutation
          description 'Generates an encrypted totp secret'

          field :secret, String, null: true, description: 'The created secret'
          field :signed_secret, String, null: true, description: 'The created and signed secret'

          def resolve
            response = ::Users::Mfa::Totp::GenerateSecretService.new(current_authentication).execute

            return response.to_mutation_response unless response.success?

            {
              secret: response.payload[:secret],
              signed_secret: response.payload[:signed_secret],
              errors: [],
            }
          end
        end
      end
    end
  end
end
