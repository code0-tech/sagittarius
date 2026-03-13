# frozen_string_literal: true

class RuntimeFunctionDefinitionDataTypeLink < ApplicationRecord
  belongs_to :runtime_function_definition, inverse_of: :runtime_function_definition_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
