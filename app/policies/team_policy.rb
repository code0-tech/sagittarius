# frozen_string_literal: true

class TeamPolicy < BasePolicy
  condition(:is_member) { @subject.team_members.any? { |member| member.user.id == @user&.id } }

  rule { is_member }.policy do
    enable :read_team
    enable :read_team_member
  end
end
