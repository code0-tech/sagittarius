# frozen_string_literal: true

module Organizations
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization

    def initialize(current_user, organization)
      @current_user = current_user
      @organization = organization
    end

    def execute
      unless Ability.allowed?(current_user, :delete_organization, organization)
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
          author_id: current_user.id,
          entity: organization,
          details: {},
          target: organization
        )

        ServiceResponse.success(message: 'Organization deleted', payload: organization)
      end
    end
  end
end
