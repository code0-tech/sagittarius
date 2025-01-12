# frozen_string_literal: true

class RuntimeFunctionDefinition < ApplicationRecord
  belongs_to :return_type, class_name: 'DataType'
  belongs_to :namespace

  has_many :parameters, class_name: 'RuntimeParameterDefinition', inverse_of: :runtime_function_definition

  validates :runtime_name, presence: true, length: { minimum: 3, maximum: 50 },
                           uniqueness: { case_sensitive: false, scope: :namespace_id }
end
