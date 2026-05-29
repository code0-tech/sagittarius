# frozen_string_literal: true

class NamespaceProjectRuntimeAssignmentPolicy < BasePolicy
  include CustomizablePermission

  delegate { subject.namespace_project }

  namespace_resolver { |runtime_assignment| runtime_assignment.namespace_project.namespace }

  rule { can?(:read_namespace_project) }.enable :read_namespace_project_runtime_assignment
  customizable_permission :update_module_configurations
end
