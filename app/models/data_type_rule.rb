# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    contains_key: 1,
    contains_type: 2,
    item_of_collection: 3,
    number_range: 4,
    regex: 5,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :types

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }
end
