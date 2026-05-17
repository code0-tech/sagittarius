# frozen_string_literal: true

class ParameterDefinition < ApplicationRecord
  include HasTranslation

  belongs_to :runtime_parameter_definition

  belongs_to :function_definition, inverse_of: :parameter_definitions

  has_many :node_parameters, inverse_of: :parameter_definition

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description
  has_translation :documentations, purpose: :documentation

  validate :function_definition_matches_definition

  def function_definition_matches_definition
    parameter_function_definition_id = runtime_parameter_definition&.runtime_function_definition_id
    function_definition_id = function_definition&.runtime_function_definition_id
    return if parameter_function_definition_id == function_definition_id

    errors.add(:function_definition, :runtime_function_definition_mismatch)
  end

  def to_grpc
    Tucana::Shared::ParameterDefinition.new(
      runtime_name: runtime_parameter_definition.runtime_name,
      default_value: Tucana::Shared::Value.from_ruby(default_value),
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      documentation: documentations.map(&:to_grpc)
    )
  end
end
