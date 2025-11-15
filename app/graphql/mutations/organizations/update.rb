# frozen_string_literal: true

module Mutations
  module Organizations
    class Update < BaseMutation
      description 'Update an existing organization.'

      field :organization, Types::OrganizationType, null: true, description: 'The updated organization.'

      argument :name, String, required: true, description: 'Name for the new organization.'
      argument :organization_id, Types::GlobalIdType[::Organization],
               required: true,
               description: 'ID of the organization to update.'

      def resolve(organization_id:, **params)
        organization = SagittariusSchema.object_from_id(organization_id)

        if organization.nil?
          return { organization: nil,
                   errors: [create_error(:organization_not_found, 'Invalid organization')] }
        end

        ::Organizations::UpdateService.new(
          current_authentication,
          organization,
          params
        ).execute.to_mutation_response(success_key: :organization)
      end
    end
  end
end
