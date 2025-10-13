# frozen_string_literal: true

class NamespacePolicy < BasePolicy
  include CustomizablePermission

  condition(:is_member) { subject.member?(user) }

  condition(:is_user_namespace) { subject.user_type? }
  condition(:is_owner) { subject.parent == user }

  rule { is_member }.enable :has_access

  rule { is_user_namespace & is_owner }.policy do
    enable :has_access
    enable :namespace_administrator
  end

  rule { can?(:has_access) }.policy do
    enable :read_namespace
    enable :read_namespace_member
    enable :read_namespace_member_role
    enable :read_namespace_role
    enable :read_runtime
    enable :read_datatype
    enable :read_flow_type
    enable :read_flow_type_setting
  end

  namespace_resolver { |namespace| namespace }

  customizable_permission :create_namespace_role
  customizable_permission :delete_namespace_role
  customizable_permission :invite_member
  customizable_permission :delete_member
  customizable_permission :assign_member_roles
  customizable_permission :assign_role_abilities
  customizable_permission :update_namespace_role
  customizable_permission :namespace_administrator
  customizable_permission :create_namespace_project
  customizable_permission :create_runtime
  customizable_permission :update_runtime
  customizable_permission :delete_runtime
  customizable_permission :rotate_runtime_token
  customizable_permission :assign_role_projects
end

NamespacePolicy.prepend_extensions
