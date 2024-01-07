# frozen_string_literal: true

class TeamPolicy < BasePolicy
  condition(:is_member) { @subject.member?(@user) }

  rule { is_member }.policy do
    enable :read_team
    enable :read_team_member
    enable :create_team_role
    enable :read_team_role
  end
end
