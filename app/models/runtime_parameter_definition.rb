# frozen_string_literal: true

class RuntimeParameterDefinition < ApplicationRecord
  belongs_to :runtime_function_definition, inverse_of: :parameters
  belongs_to :data_type, class_name: 'DataTypeIdentifier'

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  has_many :parameter_definitions, inverse_of: :runtime_parameter_definition

  has_many :owned_generic_types, class_name: 'GenericType', inverse_of: :owner

  validates :runtime_name, length: { minimum: 3, maximum: 50 }, presence: true,
                           uniqueness: { case_sensitive: false, scope: :runtime_function_definition_id }
end
