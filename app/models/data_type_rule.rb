# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    number_range: 1,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :types

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }
end
