# frozen_string_literal: true

module Mutations
  module Namespaces
    module Roles
      class Update < BaseMutation
        description 'Update an existing namespace role.'

        field :namespace_role, Types::NamespaceRoleType, null: true, description: 'The updated namespace role.'

        argument :name, String, required: true, description: 'Name for the namespace role.'
        argument :namespace_role_id, Types::GlobalIdType[::NamespaceRole],
                 required: true,
                 description: 'ID of the namespace role to update.'

        def resolve(namespace_role_id:, **params)
          namespace_role = SagittariusSchema.object_from_id(namespace_role_id)

          if namespace_role.nil?
            return { namespace_role: nil,
                     errors: [create_message_error('Invalid namespace role')] }
          end

          ::Namespaces::Roles::UpdateService.new(
            current_authentication,
            namespace_role,
            params
          ).execute.to_mutation_response(success_key: :namespace_role)
        end
      end
    end
  end
end
