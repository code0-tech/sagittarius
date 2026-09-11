# frozen_string_literal: true

module Mutations
  module Users
    class CompleteGuestProfile < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description '(Cloud only) Complete a guest profile with a claim token, promoting the guest to a regular user.'

      field :user_session, Types::UserSessionType, null: true, description: 'The created user session.'

      argument :claim_token, String, required: true, description: 'The claim token received for the guest user.'
      argument :firstname, String, required: false, description: 'Firstname for the user.'
      argument :lastname, String, required: false, description: 'Lastname for the user.'
      argument :password, String, required: true, description: 'Password for the user.'
      argument :password_repeat,
               String,
               required: true,
               description: 'Password repeat for the user to check for typos.'
      argument :username, String, required: true, description: 'Username for the user.'

      def resolve(claim_token:, password:, password_repeat:, **params)
        if password != password_repeat
          return { user_session: nil, errors: [create_error(:invalid_password_repeat, 'Invalid password repeat')] }
        end

        response = ::CLOUD::Users::CompleteGuestProfileService.new(
          claim_token,
          password: password,
          **params
        ).execute.to_mutation_response(success_key: :user_session)
        bypass_authorization! response, object_path: %i[user_session user namespace]
        bypass_authorization! response, object_path: %i[user_session user]
        bypass_authorization! response, object_path: :user_session
      end
    end
  end
end
