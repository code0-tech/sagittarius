# frozen_string_literal: true

class NodeParameter < ApplicationRecord
  belongs_to :runtime_parameter, class_name: 'RuntimeParameterDefinition'
  belongs_to :reference_value, optional: true
  belongs_to :function_value, class_name: 'NodeFunction', optional: true, inverse_of: :node_parameter_values
  belongs_to :node_function, class_name: 'NodeFunction', inverse_of: :node_parameters

  validate :only_one_value_present

  def to_grpc
    param = Tucana::Shared::NodeParameter.new(
      database_id: id,
      runtime_parameter_id: runtime_parameter.runtime_name
    )

    param.value = Tucana::Shared::NodeValue.new(literal_value: Tucana::Shared::Value.from_ruby({}))

    if literal_value.present?
      param.value.literal_value = Tucana::Shared::Value.from_ruby(literal_value)
    elsif reference_value.present?
      param.value.reference_value = reference_value.to_grpc
    elsif function_value.present?
      param.value.node_function_id = function_value.id
    end

    param
  end

  private

  def only_one_value_present
    values = [literal_value.present?, reference_value.present?, function_value.present?]
    return if values.count(true) == 1

    errors.add(:value,
               'Exactly one of literal_value, reference_value, or function_value must be present')
  end
end
