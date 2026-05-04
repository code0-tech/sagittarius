# frozen_string_literal: true

module Mutations
  module Users
    class UpdateOrganizationPins < BaseMutation
      description 'Update pinned organizations for a user.'

      field :user, Types::UserType, null: true, description: 'The updated user.'

      argument :user_id, Types::GlobalIdType[::User], required: true, description: 'ID of the user to update.'
      argument :organization_ids,
               [Types::GlobalIdType[::Organization]],
               required: true,
               description: 'Ordered list of organization IDs to pin for the user.'

      def resolve(user_id:, organization_ids:)
        user = SagittariusSchema.object_from_id(user_id)
        return { user: nil, errors: [create_error(:user_not_found, 'Invalid user with provided id')] } if user.nil?

        organizations = organization_ids.map { |id| SagittariusSchema.object_from_id(id) }
        if organizations.any?(&:nil?)
          return { user: nil, errors: [create_error(:organization_not_found, 'Invalid organization with provided id')] }
        end

        ::Users::UpdateOrganizationPinsService.new(
          current_authentication,
          user,
          organizations.map(&:id)
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
