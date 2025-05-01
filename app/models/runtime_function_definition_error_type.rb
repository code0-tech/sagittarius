# frozen_string_literal: true

class RuntimeFunctionDefinitionErrorType < ApplicationRecord
  belongs_to :runtime_function_definition
  belongs_to :data_type
end
