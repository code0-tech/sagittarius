# frozen_string_literal: true

module Mutations
  module Users
    class Delete < BaseMutation
      description 'Delete an existing user.'

      field :user, Types::UserType, null: true, description: 'The deleted user.'

      argument :user_id, Types::GlobalIdType[::User], required: true,
                                                      description: 'The user to delete.'

      def resolve(user_id:)
        user = SagittariusSchema.object_from_id(user_id)

        if user.nil?
          return { user: nil,
                   errors: [create_error(:user_not_found, 'Invalid user')] }
        end

        ::Users::DeleteService.new(
          current_authentication,
          user
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
