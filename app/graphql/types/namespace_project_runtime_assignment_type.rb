# frozen_string_literal: true

module Types
  class NamespaceProjectRuntimeAssignmentType < Types::BaseObject
    description 'Represents a runtime assignment for a project.'

    authorize :read_namespace_project_runtime_assignment

    field :compatible, Boolean, null: false, description: 'Whether the assigned runtime is compatible.'
    field :module_configurations, Types::ModuleConfigurationType.connection_type,
          null: false,
          description: 'Saved module configuration values for this project runtime assignment.'
    field :runtime, Types::RuntimeType, null: false, description: 'The assigned runtime.'

    id_field NamespaceProjectRuntimeAssignment
    timestamps
  end
end
