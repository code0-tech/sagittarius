# frozen_string_literal: true

class RuntimeModuleDefinition < ApplicationRecord
  belongs_to :runtime_module, inverse_of: :runtime_module_definitions

  validates :host, :endpoint, presence: true
  validates :port, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 65_535 }
end
