# frozen_string_literal: true

class NamespaceProjectPolicy < BasePolicy
  include CustomizablePermission

  namespace_resolver(&:namespace)

  condition(:can_create_projects) { can?(:create_namespace_project, subject.namespace) }

  rule { can_create_projects }.enable :read_namespace_project

  rule { can?(:read_namespace_project) }.policy do
    enable :read_flow
  end

  customizable_permission :assign_project_runtimes
  customizable_permission :read_namespace_project
  customizable_permission :update_namespace_project
  customizable_permission :delete_namespace_project
  customizable_permission :create_flows
  customizable_permission :update_flows
  customizable_permission :delete_flows
end
