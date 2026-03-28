# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    number_range: 1,
    regex: 2,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :variant

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }

  validates :config, if: :variant_number_range?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/NumberRangeRuleConfig',
                       hash_conversion: true,
                     }

  validates :config, if: :variant_regex?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/RegexRuleConfig',
                       hash_conversion: true,
                     }

  def to_grpc
    Tucana::Shared::DefinitionDataTypeRule.create(variant.to_sym, config)
  end
end
