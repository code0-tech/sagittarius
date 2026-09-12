# frozen_string_literal: true

module Mutations
  module Users
    class CreateGuestUser < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description '(Cloud only) Create a guest user account. Callable by Crater.'

      field :claim_token, String, null: true, description: 'Token the guest uses to complete their profile.'
      field :user, Types::UserType, null: true, description: 'The created guest user.'

      argument :email, String, required: true, description: 'Email for the guest user.'
      argument :username, String, required: true, description: 'Username for the guest user.'

      def resolve(**params)
        response = ::Users::CreateGuestUserService.new(current_authentication, **params).execute

        return { user: nil, claim_token: nil, errors: response.to_mutation_response[:errors] } if response.error?

        result = {
          user: response.payload,
          claim_token: response.payload.generate_token_for(:guest_claim),
          errors: [],
        }
        bypass_authorization! result, object_path: :user
        result
      end
    end
  end
end
