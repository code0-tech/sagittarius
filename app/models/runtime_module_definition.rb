# frozen_string_literal: true

class RuntimeModuleDefinition < ApplicationRecord
  belongs_to :runtime_module, inverse_of: :runtime_module_definitions

  validates :host, presence: true, length: { maximum: 253 }
  validates :endpoint, presence: true, length: { maximum: 2048 }
  validates :port, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 65_535 }

  def nilify_attributes!(except = %w[id runtime_module_id created_at updated_at])
    attribute_names.reject { |attr| except.include?(attr) }.each { |attr| self[attr] = nil }
  end
end
