# frozen_string_literal: true

module Mutations
  module Users
    class Update < BaseMutation
      description 'Update an existing user.'

      field :user, Types::UserType, null: true, description: 'The updated user.'

      argument :admin, Boolean, required: false, description: 'New global admin status for the user.'
      argument :email, String, required: false, description: 'New email for the user.'
      argument :firstname, String, required: false, description: 'New firstname for the user.'
      argument :lastname, String, required: false, description: 'New lastname for the user.'
      argument :user_id, Types::GlobalIdType[::User],
               required: true,
               description: 'ID of the user to update.'
      argument :username, String, required: false, description: 'New username for the user.'

      def resolve(user_id:, **params)
        user = SagittariusSchema.object_from_id(user_id)

        return { user: nil, errors: [create_message_error('Invalid user')] } if user.nil?

        ::Users::UpdateService.new(
          current_authentication,
          user,
          params
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
