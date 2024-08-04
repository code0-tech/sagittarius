# frozen_string_literal: true

module Mutations
  module Users
    class Login < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description 'Login to an existing user'

      field :user_session, Types::UserSessionType, null: true, description: 'The created user session'

      argument :email, String, required: false, description: 'Email of the user'
      argument :password, String, required: true, description: 'Password of the user'
      argument :username, String, required: false, description: 'Username of the user'

      argument :mfa, Types::Input::MfaInput, required: false, description: 'The data of the mfa login'

      require_one_of %i[email username]

      def resolve(args)
        response = ::Users::LoginService.new(args).execute.to_mutation_response(success_key: :user_session)
        bypass_authorization! response, object_path: %i[user_session user]
        bypass_authorization! response, object_path: :user_session
      end
    end
  end
end
