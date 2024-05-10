# frozen_string_literal: true

module Mutations
  module OrganizationLicenses
    class Create < BaseMutation
      description 'Create a new organization license.'

      field :organization_license, Types::OrganizationLicenseType, null: true, description: 'The newly created license.'

      argument :data, String, required: true, description: 'The license data.'
      argument :organization_id, ::Types::GlobalIdType[::Organization], required: true,
                                                                        description: 'The organization ID.'

      def resolve(organization_id:, data:)
        organization = SagittariusSchema.object_from_id(organization_id)

        if organization.nil?
          return { organization_license: nil,
                   errors: [create_message_error('Invalid organization')] }
        end

        ::OrganizationLicenses::CreateService.new(
          current_user,
          organization: organization,
          data: data
        ).execute.to_mutation_response(success_key: :organization_license)
      end
    end
  end
end
