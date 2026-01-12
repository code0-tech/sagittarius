# frozen_string_literal: true

class DataType < ApplicationRecord
  VARIANTS = {
    primitive: 1,
    type: 2,
    object: 3,
    datatype: 4,
    array: 5,
    error: 6,
    node: 7,
  }.with_indifferent_access

  enum :variant, VARIANTS, prefix: :variant

  belongs_to :parent_type, class_name: 'DataTypeIdentifier', inverse_of: :child_types, optional: true
  belongs_to :runtime, inverse_of: :data_types

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :rules, class_name: 'DataTypeRule', inverse_of: :data_type
  has_many :data_type_identifiers, class_name: 'DataTypeIdentifier', inverse_of: :data_type
  has_many :generic_types, class_name: 'GenericType', inverse_of: :data_type

  has_many :display_messages, -> { by_purpose(:display_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :aliases, -> { by_purpose(:alias) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :variant, presence: true,
                      inclusion: {
                        in: VARIANTS.keys.map(&:to_s),
                      }

  validate :validate_version

  validate :generic_keys_length

  validate :validate_parent, if: :parent_type_changed?

  def validate_version
    return errors.add(:version, :blank) if version.blank?

    parsed_version
  rescue ArgumentError
    errors.add(:version, :invalid)
  end

  def parsed_version
    Gem::Version.new(version)
  end

  def validate_parent
    current_type = self
    until current_type.parent_type&.data_type.nil?
      current_type = current_type.parent_type&.data_type || current_type.parent_type&.generic_type&.data_type

      if current_type == self
        errors.add(:parent_type, :recursion)
        break
      end
    end
  end

  def generic_keys_length
    errors.add(:generic_keys, 'each key must be 50 characters or fewer') if generic_keys.any? { |key| key.length > 50 }
    errors.add(:generic_keys, 'must be 30 or fewer') if generic_keys.size > 30
  end
end
