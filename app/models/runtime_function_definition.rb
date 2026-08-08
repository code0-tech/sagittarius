# frozen_string_literal: true

class RuntimeFunctionDefinition < ApplicationRecord
  include HasTranslation

  belongs_to :runtime
  belongs_to :runtime_module, inverse_of: :runtime_function_definitions

  has_many :function_definitions, inverse_of: :runtime_function_definition
  has_many :parameters, class_name: 'RuntimeParameterDefinition', inverse_of: :runtime_function_definition

  has_many :runtime_function_definition_data_type_links, inverse_of: :runtime_function_definition
  has_many :referenced_data_types, through: :runtime_function_definition_data_type_links, source: :referenced_data_type

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description
  has_translation :documentations, purpose: :documentation
  has_translation :deprecation_messages, purpose: :deprecation_message
  has_translation :display_messages, purpose: :display_message
  has_translation :aliases, purpose: :alias

  validates :runtime_name, presence: true,
                           length: { minimum: 3, maximum: 50 },
                           uniqueness: { case_sensitive: false, scope: :runtime_id }

  validates :signature, presence: true, length: { maximum: 500 }
  validates :definition_source, length: { maximum: 50 }
  validates :display_icon, length: { maximum: 100 }
  validates :design, length: { maximum: 200 }

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
      runtime_parameter_definitions: ordered_parameters.map(&:to_grpc),
      signature: signature,
      throws_error: throws_error,
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      documentation: documentations.map(&:to_grpc),
      deprecation_message: deprecation_messages.map(&:to_grpc),
      display_message: display_messages.map(&:to_grpc),
      alias: aliases.map(&:to_grpc),
      linked_data_type_identifiers: referenced_data_types.map(&:identifier),
      version: version,
      definition_source: definition_source,
      display_icon: display_icon,
      design: design
    )
  end

  def ordered_parameters
    parameters.sort_by(&:id)
  end
end
