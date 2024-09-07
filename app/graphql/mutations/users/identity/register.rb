# frozen_string_literal: true

module Mutations
  module Users
    module Identity
      class Register < BaseMutation
        include Sagittarius::Graphql::AuthorizationBypass

        description 'Register a new user via a external identity'

        field :user_session, Types::UserSessionType, null: true, description: 'The created users session'

        argument :args, Types::Input::IdentityInput, required: true, description: 'The validation object'
        argument :provider_id, String, required: true,
                                       description: 'The ID of the external provider (e.g. google, discord, gitlab...) '

        def resolve(provider_id:, args:)
          response = ::Users::Identity::RegisterService.new(
            provider_id,
            args
          ).execute.to_mutation_response(success_key: :user_session)
          bypass_authorization! response, object_path: %i[user_session user]
          bypass_authorization! response, object_path: :user_session
        end
      end
    end
  end
end
