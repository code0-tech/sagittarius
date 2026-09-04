# frozen_string_literal: true

module Mutations
  module Users
    class UpdateNamespacePins < BaseMutation
      description 'Updates the pinned namespaces for the current user, in the given order'

      field :user, ::Types::UserType, null: true, description: 'The updated user'

      argument :namespace_ids, [Types::GlobalIdType[::Namespace]],
               required: true,
               description: 'Ordered list of namespace IDs to pin for the user'

      def resolve(namespace_ids:)
        ::Users::UpdateNamespacePinsService.new(
          current_authentication,
          namespace_ids.map(&:model_id)
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
