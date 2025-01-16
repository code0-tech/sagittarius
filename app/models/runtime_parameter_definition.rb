# frozen_string_literal: true

class RuntimeParameterDefinition < ApplicationRecord
  belongs_to :runtime_function_definition, inverse_of: :parameters
  belongs_to :data_type

  validates :name, length: { minimum: 3, maximum: 50 }, presence: true,
                   uniqueness: { case_sensitive: false, scope: :runtime_function_definition_id }
end
