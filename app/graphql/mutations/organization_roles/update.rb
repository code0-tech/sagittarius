# frozen_string_literal: true

module Mutations
  module OrganizationRoles
    class Update < BaseMutation
      description 'Update an existing organisation role.'

      field :organization_role, Types::OrganizationRoleType, null: true, description: 'The updated organization role.'

      argument :name, String, required: true, description: 'Name for the new organization.'
      argument :organization_role_id, Types::GlobalIdType[::OrganizationRole],
               required: true,
               description: 'ID of the organization role to update.'

      def resolve(organization_role_id:, **params)
        organization_role = SagittariusSchema.object_from_id(organization_role_id)

        return { organization_role: nil, errors: [create_message_error('Invalid organization role')] } if organization_role.nil?

        ::OrganizationRoles::UpdateService.new(
          current_user,
          organization_role,
          params
        ).execute.to_mutation_response(success_key: :organization_role)
      end
    end
  end
end
