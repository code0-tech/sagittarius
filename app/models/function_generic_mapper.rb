# frozen_string_literal: true

class FunctionGenericMapper < ApplicationRecord
  belongs_to :runtime_function_definition, class_name: 'RuntimeFunctionDefinition', optional: true,
                                           inverse_of: :generic_mappers
  belongs_to :runtime_parameter_definition, class_name: 'RuntimeParameterDefinition', optional: true,
                                            inverse_of: :function_generic_mappers

  has_many :sources, class_name: 'DataTypeIdentifier', inverse_of: :function_generic_mapper

  validates :target, presence: true
end
