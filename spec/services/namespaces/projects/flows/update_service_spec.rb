# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::UpdateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, flow_input).execute
  end

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:starting_node) do
    create(:node_function, runtime_function: create(:runtime_function_definition, runtime: runtime))
  end
  let(:flow) { create(:flow, project: namespace_project, flow_type: create(:flow_type, runtime: runtime)) }
  let(:flow_input) do
    Struct.new(:settings, :starting_node_id, :nodes, :name, :disabled_reason).new(
      [],
      starting_node.to_global_id,
      [
        Struct.new(:id, :runtime_function_id, :next_node_id, :parameters).new(
          starting_node.to_global_id,
          starting_node.runtime_function.to_global_id,
          nil,
          []
        )
      ],
      "updated #{flow.name}",
      nil
    )
  end

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it 'does not update flow' do
      expect { service_response }.not_to change { flow.reload.updated_at }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when starting node is nil' do
      let(:params) { { project: namespace_project, flow_type: create(:flow_type), starting_node: nil } }

      it_behaves_like 'does not update'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: namespace_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates flow attributes' do
      expect { service_response }.to change { flow.reload.name }.to(flow_input.name)
    end

    it do
      is_expected.to create_audit_event(
        :flow_updated,
        author_id: current_user.id,
        entity_type: 'Flow',
        entity_id: service_response.payload.id,
        details: {
          **service_response.payload.attributes.except('created_at', 'updated_at'),
        },
        target_id: namespace_project.id,
        target_type: 'NamespaceProject'
      )
    end

    it 'queues job to update runtimes' do
      allow(UpdateRuntimesForProjectJob).to receive(:perform_later)

      service_response

      expect(UpdateRuntimesForProjectJob).to have_received(:perform_later).with(namespace_project.id)
    end
  end
end
