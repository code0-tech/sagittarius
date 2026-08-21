# frozen_string_literal: true

module Mutations
  module Users
    class UpdateOrganizationPins < BaseMutation
      description 'Updates the pinned organizations for the current user, in the given order'

      field :user, ::Types::UserType, null: true, description: 'The updated user'

      argument :organization_ids, [Types::GlobalIdType[::Organization]],
               required: true,
               description: 'Ordered list of organization IDs to pin for the user'

      def resolve(organization_ids:)
        ::Users::UpdateOrganizationPinsService.new(
          current_authentication,
          organization_ids.map(&:model_id)
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
