# frozen_string_literal: true

module Mutations
  module Users
    module Identity
      class Unlink < BaseMutation
        description 'Unlinks an external identity from an user'

        field :user_identity, Types::UserIdentityType, null: true, description: 'The removed identity'

        argument :identity_id, Types::GlobalIdType[UserIdentity], required: true,
                                                                  description: 'The ID of the identity to remove'

        def resolve(identity_id:)
          user_identity = SagittariusSchema.object_from_id(identity_id)

          if user_identity.nil?
            return { user_identity: nil,
                     errors: [create_message_error('Invalid identity')] }
          end

          ::Users::Identity::UnlinkService.new(
            current_authentication,
            user_identity
          ).execute.to_mutation_response(success_key: :user_identity)
        end
      end
    end
  end
end
