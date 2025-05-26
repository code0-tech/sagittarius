# frozen_string_literal: true

class NodeParameter < ApplicationRecord
  belongs_to :runtime_parameter, class_name: 'RuntimeParameterDefinition'
  belongs_to :reference_value, optional: true
  belongs_to :function_value, class_name: 'NodeFunction', optional: true

  validate :only_one_value_present

  private

  def only_one_value_present
    values = [literal_value.present?, reference_value.present?, function_value.present?]
    return if values.count(true) == 1

    errors.add(:base,
               'Exactly one of literal_value, reference_value, or function_value must be present')
  end
end
