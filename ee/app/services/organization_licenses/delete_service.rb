# frozen_string_literal: true

module OrganizationLicenses
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :organization_license

    def initialize(current_user, organization:, organization_license:)
      @current_user = current_user
      @organization = organization
      @organization_license = organization_license
    end

    def execute
      unless Ability.allowed?(current_user, :delete_organization_license, organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        organization_license.delete
        if organization_license.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete organization license',
            payload: organization_license.errors
          )
        end

        AuditService.audit(
          :organization_license_deleted,
          author_id: current_user.id,
          entity: organization_license,
          details: {},
          target: organization
        )

        ServiceResponse.success(message: 'Deleted organization license', payload: organization_license)
      end
    end
  end
end
