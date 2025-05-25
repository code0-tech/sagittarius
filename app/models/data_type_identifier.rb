# frozen_string_literal: true

class DataTypeIdentifier < ApplicationRecord
  belongs_to :data_type, optional: true, inverse_of: :data_type_identifiers
  belongs_to :generic_type, optional: true, inverse_of: :data_type_identifier

  has_many :generic_types, inverse_of: :data_type_identifier
  has_many :generic_mappers, inverse_of: :data_type_identifier
  has_many :function_generic_mappers, class_name: 'GenericMapper', inverse_of: :data_type_identifier

  validate :exactly_one_of_generic_key_data_type_id_generic_type_id

  private

  def exactly_one_of_generic_key_data_type_id_generic_type_id
    values = [generic_key.present?, data_type_id.present?, generic_type_id.present?]
    return if values.count(true) == 1

    errors.add(:base, 'Exactly one of generic_key, data_type_id, or generic_type_id must be present')
  end
end
