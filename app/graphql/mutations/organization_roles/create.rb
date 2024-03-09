# frozen_string_literal: true

module Mutations
  module OrganizationRoles
    class Create < BaseMutation
      description 'Create a new role in an organization.'

      field :organization_role, Types::OrganizationRoleType, description: 'The newly created organization role'

      argument :name, String, description: 'The name for the new role'
      argument :organization_id, Types::GlobalIdType[::Organization],
               description: 'The id of the organization which this role will belong to'

      def resolve(organization_id:, **params)
        organization = SagittariusSchema.object_from_id(organization_id)

        return { organization_role: nil, errors: [create_message_error('Invalid organization')] } if organization.nil?

        ::OrganizationRoles::CreateService.new(
          current_user,
          organization,
          params
        ).execute.to_mutation_response(success_key: :organization_role)
      end
    end
  end
end
