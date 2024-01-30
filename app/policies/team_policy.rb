# frozen_string_literal: true

class TeamPolicy < BasePolicy
  include CustomizablePermission

  condition(:is_member) { @subject.member?(@user) }

  rule { is_member }.policy do
    enable :read_team
    enable :read_team_member
  end

  team_resolver { |team| team }

  customizable_permission :read_team_role
  customizable_permission :create_team_role
end
