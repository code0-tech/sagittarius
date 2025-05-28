# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    contains_key: 1,
    contains_type: 2,
    item_of_collection: 3,
    number_range: 4,
    regex: 5,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :variant

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
            inclusion: {
              in: VARIANTS.keys.map(&:to_s),
            }

  validates :config, if: :variant_contains_key?, 'sagittarius/validators/json_schema': { filename: 'data_types/DataTypeContainsKeyRuleConfig', hash_conversion: true }

  validates :config, if: :variant_contains_type?, 'sagittarius/validators/json_schema': { filename: 'data_types/DataTypeContainsTypeRuleConfig', hash_conversion: true }

  validates :config, if: :variant_item_of_collection?, 'sagittarius/validators/json_schema': { filename: 'data_types/DataTypeItemOfCollectionRuleConfig', hash_conversion: true }

  validates :config, if: :variant_number_range?, 'sagittarius/validators/json_schema': { filename: 'data_types/DataTypeNumberRangeRuleConfig', hash_conversion: true }

  validates :config, if: :variant_regex?, 'sagittarius/validators/json_schema': { filename: 'data_types/DataTypeRegexRuleConfig', hash_conversion: true }

end
