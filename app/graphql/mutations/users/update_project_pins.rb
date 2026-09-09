# frozen_string_literal: true

module Mutations
  module Users
    class UpdateProjectPins < BaseMutation
      description 'Updates the pinned projects for the current user, in the given order'

      field :user, ::Types::UserType, null: true, description: 'The updated user'

      argument :project_ids, [Types::GlobalIdType[::NamespaceProject]],
               required: true,
               description: 'Ordered list of project IDs to pin for the user'

      def resolve(project_ids:)
        ::Users::UpdateProjectPinsService.new(
          current_authentication,
          project_ids.map(&:model_id)
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
