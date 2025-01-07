# frozen_string_literal: true

class NamespaceProjectPolicy < BasePolicy
  include CustomizablePermission

  namespace_resolver(&:namespace)

  condition(:can_create_projects) { can?(:create_namespace_project, subject.namespace) }

  rule { can_create_projects }.enable :read_namespace_project

  customizable_permission :read_namespace_project
  customizable_permission :update_namespace_project
  customizable_permission :delete_namespace_project
end
