# frozen_string_literal: true

module Types
  module Input
    class ModuleConfigurationInputType < Types::BaseInputObject
      description 'Input type for saving a module configuration value.'

      argument :module_configuration_definition_id, Types::GlobalIdType[::ModuleConfigurationDefinition],
               required: true,
               description: 'The configuration definition to save a value for.'
      argument :value, GraphQL::Types::JSON,
               required: false,
               description: 'The saved configuration value.'
    end
  end
end
