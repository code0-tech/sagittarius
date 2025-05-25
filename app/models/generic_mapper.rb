# frozen_string_literal: true

class GenericMapper < ApplicationRecord
  belongs_to :generic_type, inverse_of: :generic_mappers
  belongs_to :data_type_identifier, optional: true, inverse_of: :generic_mappers

  validates :target, presence: true
  validate :exactly_one_of_generic_key_or_data_type_identifier_id, :generic_key_changed?
  validate :exactly_one_of_generic_key_or_data_type_identifier_id, :data_type_identifier_changed?

  private

  def exactly_one_of_generic_key_or_data_type_identifier_id
    values = [generic_key.present?, data_type_identifier_id.present?]
    return if values.count(true) == 1

    errors.add(:base, 'Exactly one of generic_key or data_type_identifier_id must be present')
  end
end
