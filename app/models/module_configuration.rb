# frozen_string_literal: true

class ModuleConfiguration < ApplicationRecord
  belongs_to :namespace_project_runtime_assignment, inverse_of: :module_configurations
  belongs_to :module_configuration_definition, inverse_of: :module_configurations

  validates :module_configuration_definition_id,
            uniqueness: { scope: :namespace_project_runtime_assignment_id }
  validate :validate_runtime

  def to_grpc
    Tucana::Shared::ModuleConfiguration.new(
      identifier: module_configuration_definition.identifier,
      value: Tucana::Shared::Value.from_ruby(value)
    )
  end

  private

  def validate_runtime
    return if namespace_project_runtime_assignment.nil? || module_configuration_definition.nil?

    definition_runtime_id = module_configuration_definition.runtime_module.runtime_id
    assignment_runtime_id = namespace_project_runtime_assignment.runtime_id
    return if definition_runtime_id == assignment_runtime_id

    errors.add(:module_configuration_definition, 'must belong to the assigned runtime')
  end
end
