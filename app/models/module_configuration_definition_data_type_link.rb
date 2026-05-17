# frozen_string_literal: true

class ModuleConfigurationDefinitionDataTypeLink < ApplicationRecord
  belongs_to :module_configuration_definition, inverse_of: :module_configuration_definition_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
