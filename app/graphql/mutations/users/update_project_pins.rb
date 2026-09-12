# frozen_string_literal: true

module Mutations
  module Users
    class UpdateProjectPins < BaseMutation
      description 'Updates the pinned projects for the current user within a namespace, in the given order'

      field :user, ::Types::UserType, null: true, description: 'The updated user'

      argument :namespace_id, Types::GlobalIdType[::Namespace],
               required: true,
               description: 'ID of the namespace to pin the projects to'
      argument :project_ids, [Types::GlobalIdType[::NamespaceProject]],
               required: true,
               description: 'Ordered list of project IDs to pin for the user within the namespace'

      def resolve(namespace_id:, project_ids:)
        ::Users::UpdateProjectPinsService.new(
          current_authentication,
          namespace_id.model_id,
          project_ids.map(&:model_id)
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
