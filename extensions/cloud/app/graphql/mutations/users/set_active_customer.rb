# frozen_string_literal: true

module Mutations
  module Users
    class SetActiveCustomer < BaseMutation
      description '(Cloud only) Set or unset the active customer access status for a user. Used by Crater.'

      field :user, Types::UserType, null: true, description: 'The updated user.'

      argument :active, Boolean, required: true, description: 'Whether the user has an active customer.'
      argument :user_id, Types::GlobalIdType[::User], required: true, description: 'ID of the user to update.'

      def resolve(user_id:, active:)
        user = SagittariusSchema.object_from_id(user_id)

        return { user: nil, errors: [create_error(:user_not_found, 'Invalid user with provided id')] } if user.nil?

        ::Users::SetActiveCustomerService.new(
          current_authentication,
          user,
          active: active
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
