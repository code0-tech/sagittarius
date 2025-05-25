# frozen_string_literal: true

class GenericType < ApplicationRecord
  belongs_to :data_type_identifier, inverse_of: :generic_type

  has_many :generic_mappers, inverse_of: :generic_type
end
