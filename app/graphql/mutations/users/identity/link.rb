# frozen_string_literal: true

module Mutations
  module Users
    module Identity
      class Link < BaseMutation
        description 'Links an external identity to an existing user'

        field :user_identity, Types::UserIdentityType, null: true, description: 'The created user identity'

        argument :args, Types::Input::IdentityInput, required: true, description: 'The validation object'
        argument :provider_id, String, required: true,
                                       description: 'The ID of the external provider (e.g. google, discord, gitlab...) '

        def resolve(provider_id:, args:)
          ::Users::Identity::LinkService.new(
            current_user,
            provider_id,
            args
          ).execute.to_mutation_response(success_key: :user_identity)
        end
      end
    end
  end
end
