# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module Totp
        class Disable < BaseMutation
          description 'Disables TOTP MFA for the user'

          field :user, ::Types::UserType, null: true, description: 'The modified user'

          argument :mfa, Types::Input::MfaInput, required: true, description: 'The data of the mfa validation'

          def resolve(mfa:)
            ::Users::Mfa::Totp::DisableService.new(
              current_authentication,
              mfa
            ).execute.to_mutation_response(success_key: :user)
          end
        end
      end
    end
  end
end
