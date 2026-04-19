# frozen_string_literal: true

class FunctionDefinition < ApplicationRecord
  belongs_to :runtime_function_definition

  has_one :runtime, through: :runtime_function_definition

  has_many :function_definition_data_type_links, inverse_of: :function_definition
  has_many :referenced_data_types, through: :function_definition_data_type_links, source: :referenced_data_type

  has_many :node_functions, inverse_of: :function_definition
  has_many :parameter_definitions, inverse_of: :function_definition

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :deprecation_messages, -> { by_purpose(:deprecation_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :display_messages, -> { by_purpose(:display_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :aliases, -> { by_purpose(:alias) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  scope :by_node_function, ->(node_functions) { where(node_functions: node_functions) }

  def to_grpc
    Tucana::Shared::FunctionDefinition.new(
      runtime_name: runtime_name,
      parameter_definitions: parameter_definitions.map(&:to_grpc),
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
      display_icon: display_icon,
      definition_source: definition_source,
      runtime_definition_name: runtime_function_definition.runtime_name
    )
  end
end
