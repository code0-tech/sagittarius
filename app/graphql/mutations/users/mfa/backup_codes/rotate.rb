# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module BackupCodes
        class Rotate < BaseMutation
          description 'Rotates the backup codes of a user.'

          field :codes, [String], null: true, description: 'The newly rotated backup codes.'

          argument :mfa, Types::Input::MfaInput, required: false,
                                                 description: 'The mfa validation data, required when MFA is enabled.'

          def resolve(mfa: nil)
            ::Users::Mfa::BackupCodes::RotateService.new(
              current_authentication,
              mfa
            ).execute.to_mutation_response(success_key: :codes)
          end
        end
      end
    end
  end
end
