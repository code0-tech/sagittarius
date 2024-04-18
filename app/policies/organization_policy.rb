# frozen_string_literal: true

class OrganizationPolicy < BasePolicy
  include CustomizablePermission

  condition(:is_member) { @subject.member?(@user) }

  rule { is_member }.policy do
    enable :read_organization
    enable :read_organization_member
    enable :read_organization_member_role
    enable :read_organization_role
  end

  organization_resolver { |organization| organization }

  customizable_permission :create_organization_role
  customizable_permission :delete_organization_role
  customizable_permission :invite_member
  customizable_permission :delete_member
  customizable_permission :assign_member_roles
  customizable_permission :assign_role_abilities
  customizable_permission :update_organization_role
  customizable_permission :update_organization
end
