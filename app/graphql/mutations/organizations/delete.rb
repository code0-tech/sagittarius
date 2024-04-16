# frozen_string_literal: true

module Mutations
  module Organizations
    class Delete < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description 'Delete an existing organization.'

      field :organization, Types::OrganizationType, null: true, description: 'The deleted organization.'

      argument :organization_id, Types::GlobalIdType[::Organization], required: true,
                                                                      description: 'The organization to delete.'

      def resolve(organization_id:)
        organization = SagittariusSchema.object_from_id(organization_id)

        if organization.nil?
          return { organization_role: nil,
                   errors: [create_message_error('Invalid organization')] }
        end

        response = ::Organizations::DeleteService.new(
          current_user,
          organization
        ).execute.to_mutation_response(success_key: :organization)

        bypass_authorization! response, object_path: :organization
      end
    end
  end
end
