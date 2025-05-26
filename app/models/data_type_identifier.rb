# frozen_string_literal: true

class DataTypeIdentifier < ApplicationRecord
  belongs_to :data_type, optional: true, inverse_of: :data_type_identifiers
  belongs_to :generic_type, optional: true, inverse_of: :data_type_identifier
  belongs_to :runtime, inverse_of: :data_type_identifiers

  has_many :generic_types, inverse_of: :data_type_identifier
  has_many :generic_mappers, inverse_of: :data_type_identifier
  has_many :function_generic_mappers, class_name: 'GenericMapper', inverse_of: :data_type_identifier

  validate :exactly_one_of_generic_key_data_type_id_generic_type_id

  def to_grpc
    Tucana::Shared::DataTypeIdentifier.new(
      data_type_identifier: data_type.identifier,
      generic_type: generic_type&.to_grpc,
      generic_key: generic_key
    )
  end

  private

  def exactly_one_of_generic_key_data_type_id_generic_type_id
    values = [generic_key.present?, data_type.present?, generic_type.present?]
    return if values.count(true) == 1

    errors.add(:base, 'Exactly one of generic_key, data_type_id, or generic_type_id must be present')
  end
end
