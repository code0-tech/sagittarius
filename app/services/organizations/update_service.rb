# frozen_string_literal: true

module Organizations
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :params

    def initialize(current_user, organization, params)
      @current_user = current_user
      @organization = organization
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :update_organization, organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        success = organization.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update organization',
            payload: organization.errors
          )
        end

        AuditService.audit(
          :organization_updated,
          author_id: current_user.id,
          entity: organization,
          target: organization.ensure_namespace,
          details: params
        )

        ServiceResponse.success(message: 'Updated organization', payload: organization)
      end
    end
  end
end
