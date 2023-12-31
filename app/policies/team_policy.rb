# frozen_string_literal: true

class TeamPolicy < BasePolicy
  condition(:is_member) { TeamMember.exists?(team: @subject, user: @user) }

  rule { is_member }.enable :read_team
end
