# frozen_string_literal: true

class TeamPolicy < BasePolicy
  include CustomizablePermission

  condition(:is_member) { @subject.member?(@user) }

  rule { is_member }.policy do
    enable :read_team
    enable :read_team_member
    enable :read_team_member_role
    enable :read_team_role
  end

  team_resolver { |team| team }

  customizable_permission :create_team_role
  customizable_permission :invite_member
  customizable_permission :assign_member_roles
  customizable_permission :assign_role_abilities
end
