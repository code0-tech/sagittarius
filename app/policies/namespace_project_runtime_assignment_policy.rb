# frozen_string_literal: true

class NamespaceProjectRuntimeAssignmentPolicy < BasePolicy
  delegate { subject.namespace_project }

  rule { can?(:read_namespace_project) }.enable :read_namespace_project_runtime_assignment
  rule { can?(:assign_project_runtimes) }.enable :update_namespace_project_runtime_assignment
end
