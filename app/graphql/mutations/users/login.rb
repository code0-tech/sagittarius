# frozen_string_literal: true

module Mutations
  module Users
    class Login < BaseMutation
      description 'Login to an existing user'

      field :user_session, Types::UserSessionType, null: true, description: 'The created user session'

      argument :email, String, required: false, description: 'Email of the user'
      argument :password, String, required: true, description: 'Password of the user'
      argument :username, String, required: false, description: 'Username of the user'

      require_one_of %i[email username], self

      def resolve(args)
        UserLoginService.new(args).execute.to_mutation_response(success_key: :user_session)
      end
    end
  end
end
