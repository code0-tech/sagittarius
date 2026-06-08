# frozen_string_literal: true

class RuntimeModuleDefinition < ApplicationRecord
  belongs_to :runtime_module, inverse_of: :runtime_module_definitions

  validates :host, presence: true, length: { maximum: 253 }
  validates :endpoint, presence: true, length: { maximum: 2048 }
  validates :port, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 65_535 }
end
