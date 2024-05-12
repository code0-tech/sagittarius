# frozen_string_literal: true

module Mutations
  module OrganizationProjects
    class Create < BaseMutation
      description 'Creates a new organization project.'

      field :organization_project, Types::OrganizationProjectType, null: true, description: 'The newly created project.'

      argument :organization_id, Types::GlobalIdType[::Organization],
               description: 'The id of the organization which this project will belong to'

      argument :name, String, required: true, description: 'Name for the new organization project.'
      argument :description, String, required: false, description: 'Description for the new organization project.'

      def resolve(organization_id:, **params)
        organization = SagittariusSchema.object_from_id(organization_id)

        return { organization_project: nil, errors: [create_message_error('Invalid organization')] } if organization.nil?

        p ::OrganizationProjects::CreateService.new(
          current_user,
          organization: organization,
          **params
        ).execute.to_mutation_response(success_key: :organization_project)
      end
    end
  end
end
