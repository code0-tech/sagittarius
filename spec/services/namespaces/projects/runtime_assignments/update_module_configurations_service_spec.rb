# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::RuntimeAssignments::UpdateModuleConfigurationsService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), runtime_assignment, module_configurations).execute
  end

  let(:input_class) { Struct.new(:module_configuration_definition_id, :value) }
  let(:current_user) { create(:user) }
  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:runtime_assignment) do
    create(:namespace_project_runtime_assignment, namespace_project: project, runtime: runtime, compatible: true)
  end
  let(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'core') }
  let(:definition_one) do
    create(:module_configuration_definition, runtime_module: runtime_module, identifier: 'apiKey')
  end
  let(:definition_two) do
    create(:module_configuration_definition, runtime_module: runtime_module, identifier: 'region')
  end
  let(:module_configurations) do
    [
      input_class.new(definition_one.to_global_id, 'secret'),
      input_class.new(definition_two.to_global_id, 'eu-central-1')
    ]
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { ModuleConfiguration.count } }

    it do
      allow(FlowHandler).to receive(:update_runtime)

      service_response

      expect(FlowHandler).not_to have_received(:update_runtime)
    end
  end

  context 'when user has permission' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(runtime_assignment) }
    it { expect { service_response }.to change { ModuleConfiguration.count }.by(2) }

    it 'updates the runtime directly after persisting' do
      allow(FlowHandler).to receive(:update_runtime)

      service_response

      expect(FlowHandler).to have_received(:update_runtime).with(runtime)
    end

    it 'creates an audit event' do
      expect { service_response }.to create_audit_event(
        :project_module_configurations_updated,
        author_id: current_user.id,
        entity_id: runtime_assignment.id,
        entity_type: 'NamespaceProjectRuntimeAssignment',
        target_id: project.id,
        target_type: 'NamespaceProject'
      )
    end

    it 'stores values against their definitions' do
      service_response

      expect(
        runtime_assignment.reload.module_configurations.order(:module_configuration_definition_id).pluck(:value)
      ).to eq(%w[secret eu-central-1])
    end

    context 'when configurations already exist' do
      let!(:existing_configuration) do
        create(:module_configuration,
               namespace_project_runtime_assignment: runtime_assignment,
               module_configuration_definition: definition_one,
               value: 'old-secret')
      end
      let!(:removed_configuration) do
        create(:module_configuration,
               namespace_project_runtime_assignment: runtime_assignment,
               module_configuration_definition: definition_two,
               value: 'old-region')
      end
      let(:module_configurations) do
        [input_class.new(definition_one.to_global_id, 'new-secret')]
      end

      it 'replaces the saved set by definition identity' do
        expect { service_response }.to change { ModuleConfiguration.count }.by(-1)

        expect(existing_configuration.reload.value).to eq('new-secret')
        expect(ModuleConfiguration.exists?(removed_configuration.id)).to be(false)
      end
    end
  end
end
