# frozen_string_literal: true

module Mutations
  module Users
    class Create < BaseMutation
      description 'Admin-create a user.'

      field :user, Types::UserType, null: true, description: 'The created user.'

      argument :admin, Boolean, required: false, description: 'Admin status for the user.'
      argument :email, String, required: true, description: 'Email for the user.'
      argument :firstname, String, required: false, description: 'Firstname for the user.'
      argument :lastname, String, required: false, description: 'Lastname for the user.'
      argument :password, String, required: true, description: 'Password for the user.'
      argument :password_repeat,
               String,
               required: true,
               description: 'Password repeat for the user to check for typos.'
      argument :username, String, required: true, description: 'Username for the user.'

      def resolve(**params)
        if params[:password] != params.delete(:password_repeat)
          return { user: nil, errors: [create_error(:invalid_password_repeat, 'Invalid password repeat')] }
        end

        ::Users::CreateService.new(
          current_authentication,
          **params
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
