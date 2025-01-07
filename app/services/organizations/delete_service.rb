# frozen_string_literal: true

module Organizations
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :organization

    def initialize(current_authentication, organization)
      @current_authentication = current_authentication
      @organization = organization
    end

    def execute
      unless Ability.allowed?(current_authentication, :delete_organization, organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        organization.delete

        if organization.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete organization',
                                                       payload: organization.errors)
        end

        AuditService.audit(
          :organization_deleted,
          author_id: current_authentication.user.id,
          entity: organization,
          details: {},
          target: organization.ensure_namespace
        )

        ServiceResponse.success(message: 'Organization deleted', payload: organization)
      end
    end
  end
end
