# frozen_string_literal: true

module Mutations
  module Users
    class Register < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description 'Register a new user'

      field :user, Types::UserType, null: true, description: 'The created user'

      argument :email, String, required: true, description: 'Email of the user'
      argument :password, String, required: true, description: 'Password of the user'
      argument :username, String, required: true, description: 'Username of the user'

      def resolve(username:, email:, password:)
        response = ::Users::RegisterService.new(username, email,
                                                password).execute.to_mutation_response(success_key: :user)
        bypass_authorization! response, object_path: :user
      end
    end
  end
end
