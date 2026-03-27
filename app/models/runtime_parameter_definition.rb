# frozen_string_literal: true

class RuntimeParameterDefinition < ApplicationRecord
  belongs_to :runtime_function_definition, inverse_of: :parameters

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  has_many :parameter_definitions, inverse_of: :runtime_parameter_definition

  validates :runtime_name, length: { minimum: 3, maximum: 50 }, presence: true,
                           uniqueness: { case_sensitive: false, scope: :runtime_function_definition_id }

  def to_grpc
    Tucana::Shared::RuntimeParameterDefinition.new(
      runtime_name: runtime_name,
      default_value: Tucana::Shared::Value.from_ruby(default_value),
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      documentation: documentations.map(&:to_grpc)
    )
  end
end
