# frozen_string_literal: true

class FunctionGenericMapper < ApplicationRecord
  belongs_to :data_type_identifier, optional: true, inverse_of: :function_generic_mappers
  belongs_to :runtime_function_definition, class_name: 'RuntimeFunctionDefinition', optional: true,
                                           inverse_of: :generic_mappers
  belongs_to :runtime_parameter_definition, class_name: 'RuntimeParameterDefinition', optional: true,
                                            inverse_of: :function_generic_mappers

  validates :target, presence: true
  validate :exactly_one_of_generic_key_or_data_type_identifier_id

  private

  def exactly_one_of_generic_key_or_data_type_identifier_id
    values = [generic_key.present?, data_type_identifier.present?]
    return if values.count(true) == 1

    errors.add(:base, 'Exactly one of generic_key or data_type_identifier_id must be present')
  end
end
