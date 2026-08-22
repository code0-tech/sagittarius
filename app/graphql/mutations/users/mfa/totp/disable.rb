# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module Totp
        class Disable < BaseMutation
          description 'Disables TOTP MFA for the user'

          field :user, ::Types::UserType, null: true, description: 'The modified user'

          argument :current_totp, String,
                   required: true,
                   description: 'The current totp at the time to verify the mfa authentication device'

          def resolve(current_totp:)
            ::Users::Mfa::Totp::DisableService.new(
              current_authentication,
              current_totp
            ).execute.to_mutation_response(success_key: :user)
          end
        end
      end
    end
  end
end
