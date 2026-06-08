# frozen_string_literal: true

module Types
  class RuntimeModuleType < Types::BaseObject
    description 'Represents a runtime module'

    authorize :read_runtime_module

    field :author, String, null: false, description: 'Author of the runtime module'
    field :configuration_definitions, Types::ModuleConfigurationDefinitionType.connection_type,
          null: false,
          description: 'Configuration definitions of the runtime module',
          method: :module_configuration_definitions
    field :data_types, Types::DataTypeType.connection_type, null: false, description: 'Data types of the runtime module'
    field :definitions, Types::RuntimeModuleDefinitionType.connection_type,
          null: false,
          description: 'Definitions of the runtime module',
          method: :runtime_module_definitions
    field :descriptions, [Types::TranslationType], null: true, description: 'Descriptions of the runtime module'
    field :documentation, String, null: false, description: 'Documentation URL of the runtime module'
    field :flow_types, Types::FlowTypeType.connection_type, null: false, description: 'Flow types of the runtime module'
    field :function_definitions, Types::FunctionDefinitionType.connection_type,
          null: false,
          description: 'Function definitions of the runtime module'
    field :icon, String, null: true, description: 'Icon of the runtime module'
    field :identifier, String, null: false, description: 'Identifier of the runtime module'
    field :names, [Types::TranslationType], null: true, description: 'Names of the runtime module'
    field :runtime, Types::RuntimeType, null: false, description: 'Runtime of the runtime module'
    field :runtime_flow_types, Types::RuntimeFlowTypeType.connection_type,
          null: false,
          description: 'Runtime flow types of the runtime module'
    # rubocop:disable GraphQL/ExtractType
    field :runtime_function_definitions, Types::RuntimeFunctionDefinitionType.connection_type,
          null: false,
          description: 'Runtime function definitions of the runtime module'
    # rubocop:enable GraphQL/ExtractType
    field :version, String, null: false, description: 'Version of the runtime module'

    id_field RuntimeModule
    timestamps
  end
end
