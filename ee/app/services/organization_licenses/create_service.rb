# frozen_string_literal: true

module OrganizationLicenses
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :data

    def initialize(current_user, organization:, data:)
      @current_user = current_user
      @organization = organization
      @data = data
    end

    def execute
      unless Ability.allowed?(current_user, :create_organization_license, organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        organization_license = OrganizationLicense.create(data: data, organization: organization)
        unless organization_license.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create organization_license license',
            payload: organization_license.errors
          )
        end

        license_data = organization_license.license

        AuditService.audit(
          :organization_license_created,
          author_id: current_user.id,
          entity: organization_license,
          target: organization,
          details: {
            licensee: license_data.licensee,
            start_date: license_data.start_date,
            end_date: license_data.end_date,
            restrictions: license_data.restrictions,
            options: license_data.options,
          }
        )

        ServiceResponse.success(message: 'Created new organization_license', payload: organization_license)
      end
    end
  end
end
