# frozen_string_literal: true

class RuntimeFunctionDefinition < ApplicationRecord
  belongs_to :return_type, class_name: 'DataType', optional: true
  belongs_to :runtime

  has_many :function_definitions, inverse_of: :runtime_function_definition
  has_many :parameters, class_name: 'RuntimeParameterDefinition', inverse_of: :runtime_function_definition
  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :runtime_name, presence: true,
                           length: { minimum: 3, maximum: 50 },
                           uniqueness: { case_sensitive: false, scope: :runtime_id }
end
