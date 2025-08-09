# frozen_string_literal: true

class ParameterDefinition < ApplicationRecord
  belongs_to :runtime_parameter_definition
  belongs_to :data_type, class_name: 'DataTypeIdentifier'

  belongs_to :function_definition, inverse_of: :parameter_definitions

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validate :function_definition_matches_definition

  def function_definition_matches_definition
    parameter_function_definition_id = runtime_parameter_definition&.runtime_function_definition_id
    function_definition_id = function_definition&.runtime_function_definition_id
    return if parameter_function_definition_id == function_definition_id

    errors.add(:function_definition, :runtime_function_definition_mismatch)
  end
end
