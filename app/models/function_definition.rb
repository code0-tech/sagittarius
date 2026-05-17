# frozen_string_literal: true

class FunctionDefinition < ApplicationRecord
  include HasTranslation

  belongs_to :runtime, inverse_of: :function_definitions
  belongs_to :runtime_module, inverse_of: :function_definitions
  belongs_to :runtime_function_definition

  has_many :node_functions, inverse_of: :function_definition
  has_many :parameter_definitions, inverse_of: :function_definition

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description
  has_translation :documentations, purpose: :documentation
  has_translation :deprecation_messages, purpose: :deprecation_message
  has_translation :display_messages, purpose: :display_message
  has_translation :aliases, purpose: :alias

  scope :by_node_function, ->(node_functions) { where(node_functions: node_functions) }

  validates :identifier, presence: true, uniqueness: { case_sensitive: false, scope: :runtime_id }

  def to_grpc
    Tucana::Shared::FunctionDefinition.new(
      runtime_name: identifier,
      parameter_definitions: parameter_definitions.map(&:to_grpc),
      signature: runtime_function_definition.signature,
      throws_error: runtime_function_definition.throws_error,
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      documentation: documentations.map(&:to_grpc),
      deprecation_message: deprecation_messages.map(&:to_grpc),
      display_message: display_messages.map(&:to_grpc),
      alias: aliases.map(&:to_grpc),
      linked_data_type_identifiers: runtime_function_definition.referenced_data_types.map(&:identifier),
      version: runtime_function_definition.version,
      display_icon: runtime_function_definition.display_icon,
      definition_source: runtime_function_definition.definition_source,
      runtime_definition_name: runtime_function_definition.runtime_name
    )
  end
end
