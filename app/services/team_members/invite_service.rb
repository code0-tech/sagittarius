# frozen_string_literal: true

module TeamMembers
  class InviteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :team, :user

    def initialize(current_user, team, user)
      @current_user = current_user
      @team = team
      @user = user
    end

    def execute
      unless Ability.allowed?(current_user, :invite_member, team)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        team_member = TeamMember.create(team: team, user: user)

        unless team_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to save team member',
                                                       payload: team_member.errors)
        end

        AuditService.audit(
          :team_member_invited,
          author_id: current_user.id,
          entity: team_member,
          details: {},
          target: team
        )

        ServiceResponse.success(message: 'Team member invited', payload: team_member)
      end
    end
  end
end
