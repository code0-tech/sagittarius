# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    contains_key: 1,
    contains_type: 2,
    item_of_collection: 3,
    number_range: 4,
    regex: 5,
    return_type: 6,
    input_types: 7,
    parent_type: 8,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :variant

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }

  validates :config, if: :variant_contains_key?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/ContainsKeyRuleConfig',
                       hash_conversion: true,
                     }

  validates :config, if: :variant_contains_type?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/ContainsTypeRuleConfig',
                       hash_conversion: true,
                     }

  validates :config, if: :variant_item_of_collection?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/ItemOfCollectionRuleConfig',
                       hash_conversion: true,
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

  validates :config, if: :variant_return_type?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/ReturnTypeRuleConfig',
                       hash_conversion: true,
                     }

  validates :config, if: :variant_input_types?,
                     'sagittarius/validators/json_schema': {
                       filename: 'data_types/InputTypesRuleConfig',
                       hash_conversion: true,
                     }

  validate :no_parent_type_config, if: :variant_parent_type?

  def no_parent_type_config
    errors.add(:config, :not_blank) if config.present?
  end
end
