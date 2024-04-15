# frozen_string_literal: true

module Mutations
  module OrganizationRoles
    class Delete < BaseMutation
      description 'Delete an existing role in an organization.'

      field :organization_role, Types::OrganizationRoleType, description: 'The deleted organization role'

      argument :organization_role_id, Types::GlobalIdType[::OrganizationRole],
               description: 'The id of the organization role which will be deleted'

      def resolve(organization_role_id:)
        organization_role = SagittariusSchema.object_from_id(organization_role_id)

        if organization_role.nil?
          return { organization_role: nil,
                   errors: [create_message_error('Invalid organization role')] }
        end

        ::OrganizationRoles::DeleteService.new(
          current_user,
          organization_role
        ).execute.to_mutation_response(success_key: :organization_role)
      end
    end
  end
end
