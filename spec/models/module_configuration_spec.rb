# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModuleConfiguration do
  subject(:module_configuration) { create(:module_configuration) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace_project_runtime_assignment).inverse_of(:module_configurations) }
    it { is_expected.to belong_to(:module_configuration_definition).inverse_of(:module_configurations) }
  end

  describe 'validations' do
    it do
      is_expected.to validate_uniqueness_of(:module_configuration_definition_id)
        .scoped_to(:namespace_project_runtime_assignment_id)
    end

    it 'requires the definition to belong to the assigned runtime' do
      assignment = create(:namespace_project_runtime_assignment)
      other_runtime = create(:runtime, namespace: assignment.namespace_project.namespace)
      other_runtime_module = create(:runtime_module, runtime: other_runtime)
      other_definition = create(:module_configuration_definition, runtime_module: other_runtime_module)

      module_configuration.module_configuration_definition = other_definition

      expect(module_configuration).not_to be_valid
      expect(module_configuration.errors[:module_configuration_definition]).to include(
        'must belong to the assigned runtime'
      )
    end
  end

  describe '#to_grpc' do
    it 'serializes the identifier and value' do
      grpc_configuration = module_configuration.to_grpc

      expect(grpc_configuration.identifier).to eq(module_configuration.module_configuration_definition.identifier)
      expect(grpc_configuration.value.to_ruby(true)).to eq(module_configuration.value)
    end
  end
end
