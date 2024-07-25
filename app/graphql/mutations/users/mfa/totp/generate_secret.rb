# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module Totp
        class GenerateSecret < BaseMutation
          description 'Generates an encrypted totp secret'

          field :secret, String, null: true, description: 'The created user session'

          def resolve
            ::Users::Mfa::Totp::GenerateSecretService.new(current_user).execute
                                                     .to_mutation_response(success_key: :secret)
          end
        end
      end
    end
  end
end
