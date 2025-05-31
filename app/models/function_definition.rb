# frozen_string_literal: true

class FunctionDefinition < ApplicationRecord
  belongs_to :runtime_function_definition
  belongs_to :return_type, class_name: 'DataTypeIdentifier', optional: true

  has_many :generic_combination_strategies,
           class_name: 'GenericCombinationStrategy', inverse_of: :function_generic_mapper

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
