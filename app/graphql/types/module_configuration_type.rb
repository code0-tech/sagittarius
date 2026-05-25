# frozen_string_literal: true

module Types
  class ModuleConfigurationType < Types::BaseObject
    description 'Represents a saved module configuration value for a project runtime assignment.'

    authorize :read_module_configuration

    field :definition, Types::ModuleConfigurationDefinitionType,
          null: false,
          method: :module_configuration_definition,
          description: 'The configuration definition this saved value belongs to.'
    field :value, GraphQL::Types::JSON,
          null: true,
          description: 'The saved configuration value.'

    id_field ModuleConfiguration
    timestamps
  end
end
