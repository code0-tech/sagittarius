# frozen_string_literal: true

class GenericCombinationStrategy < ApplicationRecord
  TYPES = {
    and: 1,
    or: 2,
  }.with_indifferent_access

  belongs_to :generic_mapper, optional: true, inverse_of: :generic_combination_strategies
  belongs_to :function_generic_mapper, optional: true, inverse_of: :generic_combination_strategies

  enum :type, TYPES, prefix: :type
end
