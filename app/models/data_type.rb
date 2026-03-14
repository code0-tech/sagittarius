# frozen_string_literal: true

class DataType < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :runtime, inverse_of: :data_types

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :rules, class_name: 'DataTypeRule', inverse_of: :data_type

  has_many :data_type_data_type_links, inverse_of: :data_type
  has_many :referenced_data_types, through: :data_type_data_type_links, source: :referenced_data_type

  has_many :display_messages, -> { by_purpose(:display_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :aliases, -> { by_purpose(:alias) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :type, presence: true, length: { maximum: 2000 }

  validate :validate_version

  def validate_version
    return errors.add(:version, :blank) if version.blank?

    parsed_version
  rescue ArgumentError
    errors.add(:version, :invalid)
  end

  def parsed_version
    Gem::Version.new(version)
  end
end
