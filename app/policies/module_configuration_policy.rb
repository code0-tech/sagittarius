# frozen_string_literal: true

class ModuleConfigurationPolicy < BasePolicy
  delegate { subject.namespace_project_runtime_assignment }

  rule { can?(:read_namespace_project_runtime_assignment) }.enable :read_module_configuration
end
