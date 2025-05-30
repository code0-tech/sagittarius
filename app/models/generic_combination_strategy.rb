# frozen_string_literal: true

class GenericCombinationStrategy < ApplicationRecord
  TYPES = {
    and: 1,
    or: 2,
  }.with_indifferent_access

  belongs_to :generic_mapper

  enum :type, TYPES, prefix: :type
end
