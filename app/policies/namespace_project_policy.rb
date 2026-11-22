# frozen_string_literal: true

class NamespaceProjectPolicy < BasePolicy
  include CustomizablePermission

  namespace_resolver(&:namespace)

  condition(:can_create_projects) { can?(:create_namespace_project, subject.namespace) }

  rule { can_create_projects }.enable :read_namespace_project

  # Runtimes authenticate as a Runtime (see ApplicationController#create_authentication) and act on the
  # projects they are assigned to.
  condition(:assigned_runtime) do
    authentication.type == :runtime &&
      subject.runtime_assignments.exists?(runtime_id: authentication.authentication.id)
  end

  rule { can?(:read_namespace_project) }.policy do
    enable :read_flow
    enable :read_storage_object
  end

  rule { assigned_runtime }.policy do
    enable :read_storage_object
    enable :create_storage_object
  end

  rule { admin }.policy do
    enable :namespace_administrator
  end

  customizable_permission :assign_project_runtimes
  customizable_permission :read_namespace_project
  customizable_permission :update_namespace_project
  customizable_permission :delete_namespace_project
  customizable_permission :create_flow
  customizable_permission :update_flow
  customizable_permission :delete_flow
  customizable_permission :create_storage_object
  customizable_permission :delete_storage_object
end
