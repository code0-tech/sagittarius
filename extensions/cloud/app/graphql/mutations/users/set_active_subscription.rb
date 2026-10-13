# frozen_string_literal: true

module Mutations
  module Users
    class SetActiveSubscription < BaseMutation
      description '(Cloud only) Set or unset the active subscription status for a user. Used by Crater.'

      field :user, Types::UserType, null: true, description: 'The updated user.'

      argument :active, Boolean, required: true, description: 'Whether the user has an active subscription.'
      argument :user_id, Types::GlobalIdType[::User], required: true, description: 'ID of the user to update.'

      def resolve(user_id:, active:)
        user = SagittariusSchema.object_from_id(user_id)

        return { user: nil, errors: [create_error(:user_not_found, 'Invalid user with provided id')] } if user.nil?

        ::Users::SetActiveSubscriptionService.new(
          current_authentication,
          user,
          active: active
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
