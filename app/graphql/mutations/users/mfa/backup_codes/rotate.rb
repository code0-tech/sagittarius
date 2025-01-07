# frozen_string_literal: true

module Mutations
  module Users
    module Mfa
      module BackupCodes
        class Rotate < BaseMutation
          description 'Rotates the backup codes of a user.'

          field :codes, [String], null: true, description: 'The newly rotated backup codes.'

          def resolve
            ::Users::Mfa::BackupCodes::RotateService.new(
              current_authentication
            ).execute.to_mutation_response(success_key: :codes)
          end
        end
      end
    end
  end
end
