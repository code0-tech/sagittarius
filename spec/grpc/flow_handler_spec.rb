# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowHandler do
  describe '.grouped_module_configurations' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project) }
    let(:assignment) do
      create(:namespace_project_runtime_assignment,
             namespace_project: project,
             runtime: runtime,
             compatible: true)
    end
    let(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'example-action') }
    let!(:saved_definition) do
      create(:module_configuration_definition,
             runtime_module: runtime_module,
             identifier: 'EXAMPLE_CONFIG',
             default_value: 'default')
    end
    let(:default_definition) do
      create(:module_configuration_definition,
             runtime_module: runtime_module,
             identifier: 'SECOND_CONFIG',
             default_value: 'second-default')
    end

    before do
      create(:module_configuration,
             namespace_project_runtime_assignment: assignment,
             module_configuration_definition: saved_definition,
             value: 'saved')
    end

    it 'uses saved values and falls back to definition defaults for missing project values' do
      default_definition

      module_configurations = described_class.grouped_module_configurations([assignment], [runtime_module])

      expect(module_configurations.length).to eq(1)
      expect(module_configurations.first.module_identifier).to eq('example-action')

      project_configurations = module_configurations.first.module_configurations.sole
      expect(project_configurations.project_id).to eq(project.id)
      expect(
        project_configurations.module_configurations.map do |configuration|
          [configuration.identifier, configuration.value.to_ruby(true)]
        end
      ).to eq(
        [
          %w[EXAMPLE_CONFIG saved],
          %w[SECOND_CONFIG second-default]
        ]
      )
    end
  end
end
