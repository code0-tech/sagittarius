# frozen_string_literal: true

module Types
  class RuntimeFlowTypeType < Types::BaseObject
    description 'Represents a runtime flow type'

    authorize :read_runtime_flow_type

    field :aliases, [Types::TranslationType], null: true, description: 'Aliases of the runtime flow type'
    field :definition_source, String, null: true, description: 'The source that defines this runtime flow type'
    field :descriptions, [Types::TranslationType], null: true,
                                                   description: 'Descriptions of the runtime flow type'
    # rubocop:disable GraphQL/ExtractType
    field :display_icon, String, null: true, description: 'Display icon of the runtime flow type'
    field :display_messages, [Types::TranslationType], null: true,
                                                       description: 'Display message of the runtime flow type'
    # rubocop:enable GraphQL/ExtractType
    field :documentations, [Types::TranslationType], null: true,
                                                     description: 'Documentations of the runtime flow type'
    field :editable, Boolean, null: false, description: 'Editable status of the runtime flow type'
    field :flow_types, Types::FlowTypeType.connection_type, null: false,
                                                            description: 'Flow types backed by this runtime flow type'
    field :identifier, String, null: false, description: 'Identifier of the runtime flow type'
    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this runtime flow type'
    field :names, [Types::TranslationType], null: true, description: 'Names of the runtime flow type'
    field :runtime, Types::RuntimeType, null: false, description: 'Runtime of the runtime flow type'
    field :runtime_flow_type_settings, [Types::RuntimeFlowTypeSettingType],
          null: false,
          description: 'Runtime flow type settings of the runtime flow type'
    # rubocop:disable GraphQL/ExtractType
    field :runtime_module, Types::RuntimeModuleType, null: false,
                                                     description: 'Runtime module of the runtime flow type'
    # rubocop:enable GraphQL/ExtractType
    field :signature, String, null: false, description: 'Signature of the runtime flow type'
    field :version, String, null: false, description: 'Version of the runtime flow type'

    id_field RuntimeFlowType
    timestamps

    def linked_data_types
      DataTypesFinder.new({ runtime_flow_type: object, expand_recursively: true }).execute
    end
  end
end
