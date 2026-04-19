# frozen_string_literal: true

class FunctionDefinitionDataTypeLink < ApplicationRecord
  belongs_to :function_definition, inverse_of: :function_definition_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
