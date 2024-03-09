# frozen_string_literal: true

module OrganizationRoles
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :params

    def initialize(current_user, organization, params)
      @current_user = current_user
      @organization = organization
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :create_organization_role, organization)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do
        organization_role = OrganizationRole.create(organization: organization, **params)

        unless organization_role.persisted?
          return ServiceResponse.error(message: 'Failed to save organization role', payload: organization_role.errors)
        end

        AuditService.audit(
          :organization_role_created,
          author_id: current_user.id,
          entity: organization_role,
          details: { name: params[:name] },
          target: organization
        )

        ServiceResponse.success(message: 'Organization role created', payload: organization_role)
      end
    end
  end
end
