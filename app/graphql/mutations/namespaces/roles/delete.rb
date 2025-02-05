# frozen_string_literal: true

module Mutations
  module Namespaces
    module Roles
      class Delete < BaseMutation
        description 'Delete an existing role in a namespace.'

        field :namespace_role, Types::NamespaceRoleType, description: 'The deleted namespace role'

        argument :namespace_role_id, Types::GlobalIdType[::NamespaceRole],
                 description: 'The id of the namespace role which will be deleted'

        def resolve(namespace_role_id:)
          namespace_role = SagittariusSchema.object_from_id(namespace_role_id)

          if namespace_role.nil?
            return { namespace_role: nil,
                     errors: [create_message_error('Invalid namespace role')] }
          end

          ::Namespaces::Roles::DeleteService.new(
            current_authentication,
            namespace_role
          ).execute.to_mutation_response(success_key: :namespace_role)
        end
      end
    end
  end
end
