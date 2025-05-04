# frozen_string_literal: true

module Mutations
  module Users
    class Register < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description 'Register a new user'

      field :user_session, Types::UserSessionType, null: true, description: 'The created users session'

      argument :email, String, required: true, description: 'Email of the user'
      argument :password, String, required: true, description: 'Password of the user'
      argument :password_repeat, String, required: true,
                                         description: 'The repeated password of the user to check for typos'
      argument :username, String, required: true, description: 'Username of the user'

      def resolve(username:, email:, password:, password_repeat:)
        return { user: nil, errors: [create_message_error('Invalid password repeat')] } if password != password_repeat

        response = ::Users::RegisterService.new(
          username,
          email,
          password
        ).execute.to_mutation_response(success_key: :user_session)
        bypass_authorization! response, object_path: %i[user_session user]
        bypass_authorization! response, object_path: :user_session
      end
    end
  end
end
