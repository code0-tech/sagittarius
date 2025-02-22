# frozen_string_literal: true

module Mutations
  module Namespaces
    module Roles
      class Create < BaseMutation
        description 'Create a new role in a namespace.'

        field :namespace_role, Types::NamespaceRoleType, description: 'The newly created namespace role'

        argument :name, String, description: 'The name for the new role'
        argument :namespace_id, Types::GlobalIdType[::Namespace],
                 description: 'The id of the namespace which this role will belong to'

        def resolve(namespace_id:, **params)
          namespace = SagittariusSchema.object_from_id(namespace_id)

          return { namespace_role: nil, errors: [create_message_error('Invalid namespace')] } if namespace.nil?

          ::Namespaces::Roles::CreateService.new(
            current_authentication,
            namespace,
            params
          ).execute.to_mutation_response(success_key: :namespace_role)
        end
      end
    end
  end
end
