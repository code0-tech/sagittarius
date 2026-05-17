# frozen_string_literal: true

module Types
  class ModuleConfigurationDefinitionType < Types::BaseObject
    description 'Represents a module configuration definition'

    authorize :read_module_configuration_definition

    field :default_value, GraphQL::Types::JSON, null: true,
                                                description: 'Default value of the module configuration definition'
    field :descriptions, [Types::TranslationType], null: true,
                                                   description: 'Descriptions of the module configuration definition'
    field :hidden, Boolean, null: false, description: 'Indicates if the configuration definition is hidden'
    field :identifier, String, null: false, description: 'Identifier of the module configuration definition'
    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this module configuration definition'
    field :names, [Types::TranslationType], null: true, description: 'Names of the module configuration definition'
    field :optional, Boolean, null: false, description: 'Indicates if the configuration definition is optional'
    field :runtime_module, Types::RuntimeModuleType, null: false,
                                                     description: 'Runtime module of the configuration definition'
    field :type, String, null: false, description: 'Type of the module configuration definition'

    id_field ModuleConfigurationDefinition
    timestamps

    def linked_data_types
      DataTypesFinder.new({ module_configuration_definition: object, expand_recursively: true }).execute
    end
  end
end
