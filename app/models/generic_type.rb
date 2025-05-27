# frozen_string_literal: true

class GenericType < ApplicationRecord
  belongs_to :data_type, class_name: 'DataType', inverse_of: :generic_types
  belongs_to :runtime, class_name: 'Runtime', inverse_of: :generic_types

  has_many :generic_mappers, inverse_of: :generic_type
  has_many :data_type_identifiers, class_name: 'DataTypeIdentifier', inverse_of: :generic_type

  def to_grcp
    Tucana::Sagittarius::GenericType.new(
      data_type_identifier: data_type_identifier&.data_type&.identifier,
      generic_mappers: generic_mappers.map(&:to_grcp)
    )
  end
end
