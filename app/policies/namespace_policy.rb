# frozen_string_literal: true

class NamespacePolicy < BasePolicy
  include CustomizablePermission

  condition(:is_member) { @subject.member?(@user) }

  rule { is_member }.policy do
    enable :read_namespace
    enable :read_namespace_member
    enable :read_namespace_member_role
    enable :read_namespace_role
    enable :read_runtime
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
end

NamespacePolicy.prepend_extensions
