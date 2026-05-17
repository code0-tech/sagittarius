# frozen_string_literal: true

class DataType < ApplicationRecord
  include HasTranslation

  self.inheritance_column = :_type_disabled

  belongs_to :runtime, inverse_of: :data_types
  belongs_to :runtime_module, inverse_of: :data_types

  has_translation :names, purpose: :name
  has_many :rules, class_name: 'DataTypeRule', inverse_of: :data_type

  has_many :data_type_data_type_links, inverse_of: :data_type
  has_many :referenced_data_types, through: :data_type_data_type_links, source: :referenced_data_type

  has_translation :display_messages, purpose: :display_message
  has_translation :aliases, purpose: :alias

  validates :type, presence: true, length: { maximum: 2000 }
  validates :definition_source, length: { maximum: 50 }

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

  def to_grpc
    Tucana::Shared::DefinitionDataType.new(
      identifier: identifier,
      name: names.map(&:to_grpc),
      display_message: display_messages.map(&:to_grpc),
      alias: aliases.map(&:to_grpc),
      rules: rules.map(&:to_grpc),
      generic_keys: generic_keys,
      type: type,
      linked_data_type_identifiers: referenced_data_types.map(&:identifier),
      version: version,
      definition_source: definition_source
    )
  end
end
