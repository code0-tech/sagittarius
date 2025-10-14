# frozen_string_literal: true

class DataTypeIdentifier < ApplicationRecord
  belongs_to :data_type, optional: true, inverse_of: :data_type_identifiers
  belongs_to :generic_type, optional: true, inverse_of: :data_type_identifiers
  belongs_to :runtime, inverse_of: :data_type_identifiers
  belongs_to :generic_mapper, class_name: 'GenericMapper', optional: true, inverse_of: :sources

  has_many :child_types, class_name: 'DataType', inverse_of: :parent_type

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
