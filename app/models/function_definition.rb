# frozen_string_literal: true

class FunctionDefinition < ApplicationRecord
  belongs_to :runtime_function_definition
  belongs_to :return_type, class_name: 'DataType', optional: true

  has_many :translations, class_name: 'Translation', as: :owner
end
