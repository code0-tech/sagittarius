# frozen_string_literal: true

module TeamRoles
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :team, :params

    def initialize(current_user, team, params)
      @current_user = current_user
      @team = team
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :create_organization_role, team)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do
        organization_role = OrganizationRole.create(team: team, **params)

        unless organization_role.persisted?
          return ServiceResponse.error(message: 'Failed to save organization role', payload: organization_role.errors)
        end

        AuditService.audit(
          :organization_role_created,
          author_id: current_user.id,
          entity: organization_role,
          details: { name: params[:name] },
          target: team
        )

        ServiceResponse.success(message: 'Organization role created', payload: organization_role)
      end
    end
  end
end
