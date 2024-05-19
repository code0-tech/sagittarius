# frozen_string_literal: true

module Mutations
  module OrganizationLicenses
    class Delete < BaseMutation
      description 'Deletes an organization license.'

      field :organization_license, Types::OrganizationLicenseType, null: true,
                                                                   description: 'The deleted organization license.'

      argument :organization_id, ::Types::GlobalIdType[::Organization], required: true,
                                                                        description: 'The organization ID.'
      argument :organization_license_id, ::Types::GlobalIdType[::OrganizationLicense],
               required: true,
               description: 'The license id to delete.'

      def resolve(organization_id:, organization_license_id:)
        organization = SagittariusSchema.object_from_id(organization_id)
        license = SagittariusSchema.object_from_id(organization_license_id)

        if organization.nil?
          return { organization_license: nil,
                   errors: [create_message_error('Invalid organization')] }
        end

        if license.nil?
          return { organization_license: nil,
                   errors: [create_message_error('Invalid license')] }
        end

        ::OrganizationLicenses::DeleteService.new(
          current_user,
          organization: organization,
          organization_license: license
        ).execute.to_mutation_response(success_key: :organization_license)
      end
    end
  end
end
