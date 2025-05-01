# frozen_string_literal: true

class RuntimeFunctionDefinition < ApplicationRecord
  belongs_to :return_type, class_name: 'DataType', optional: true
  belongs_to :runtime

  has_many :function_definitions, inverse_of: :runtime_function_definition
  has_many :parameters, class_name: 'RuntimeParameterDefinition', inverse_of: :runtime_function_definition
  has_many :error_types, class_name: 'RuntimeFunctionDefinitionErrorType', inverse_of: :runtime_function_definition

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :deprecation_messages, lambda {
    by_purpose(:deprecation_message)
  }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :runtime_name, presence: true,
                           length: { minimum: 3, maximum: 50 },
                           uniqueness: { case_sensitive: false, scope: :runtime_id }
end
