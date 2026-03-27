# frozen_string_literal: true

class RuntimeFunctionDefinition < ApplicationRecord
  belongs_to :runtime

  has_many :function_definitions, inverse_of: :runtime_function_definition
  has_many :parameters, class_name: 'RuntimeParameterDefinition', inverse_of: :runtime_function_definition

  has_many :runtime_function_definition_data_type_links, inverse_of: :runtime_function_definition
  has_many :referenced_data_types, through: :runtime_function_definition_data_type_links, source: :referenced_data_type

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :deprecation_messages, lambda {
    by_purpose(:deprecation_message)
  }, class_name: 'Translation', as: :owner, inverse_of: :owner

  has_many :display_messages, -> { by_purpose(:display_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :aliases, -> { by_purpose(:alias) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :runtime_name, presence: true,
                           length: { minimum: 3, maximum: 50 },
                           uniqueness: { case_sensitive: false, scope: :runtime_id }

  validates :signature, presence: true, length: { maximum: 500 }

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
    Tucana::Shared::RuntimeFunctionDefinition.new(
      runtime_name: runtime_name,
      runtime_parameter_definitions: parameters.map(&:to_grpc),
      signature: signature,
      throws_error: throws_error,
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      documentation: documentations.map(&:to_grpc),
      deprecation_message: deprecation_messages.map(&:to_grpc),
      display_message: display_messages.map(&:to_grpc),
      alias: aliases.map(&:to_grpc),
      linked_data_type_identifiers: referenced_data_types.map(&:identifier),
      version: version
    )
  end
end
