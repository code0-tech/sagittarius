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
      unless Ability.allowed?(current_user, :create_team_role, team)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do
        team_role = TeamRole.create(team: team, **params)

        unless team_role.persisted?
          return ServiceResponse.error(message: 'Failed to save team role', payload: team_role.errors)
        end

        AuditService.audit(
          :team_role_created,
          author_id: current_user.id,
          entity: team_role,
          details: { name: params[:name] },
          target: team
        )

        ServiceResponse.success(message: 'Team role created', payload: team_role)
      end
    end
  end
end
