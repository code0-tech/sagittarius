# frozen_string_literal: true

module Teams
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :name

    def initialize(current_user, name:)
      @current_user = current_user
      @name = name
    end

    def execute
      unless Ability.allowed?(current_user, :create_team)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        team = Team.create(name: name)
        unless team.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to create team', payload: team.errors)
        end

        organization_member = OrganizationMember.create(team: team, user: current_user)
        unless organization_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization member',
                                                       payload: organization_member.errors)
        end

        AuditService.audit(
          :team_created,
          author_id: current_user.id,
          entity: team,
          target: team,
          details: { name: name }
        )

        ServiceResponse.success(message: 'Created new team', payload: team)
      end
    end
  end
end
