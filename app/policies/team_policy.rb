# frozen_string_literal: true

class TeamPolicy < BasePolicy
  condition(:is_member) { TeamMember.exists?(team: @subject, user: @user) }

  rule { is_member }.policy do
    enable :read_team
    enable :read_team_member
  end
end
