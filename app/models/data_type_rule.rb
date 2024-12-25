# frozen_string_literal: true

class DataTypeRule < ApplicationRecord
  VARIANTS = {
    dummy: 1, # TODO: implement actual rules
    number_range: 2,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :types

  belongs_to :data_type, inverse_of: :rules

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }
end
