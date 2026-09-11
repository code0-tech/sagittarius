# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::DeleteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow: flow).execute }

  let(:namespace_project) { create(:namespace_project) }
  let(:starting_node) { create(:node_function) }
  let(:flow_type) { create(:flow_type) }
  let!(:flow) { create(:flow, project: namespace_project, flow_type: flow_type, starting_node: starting_node) }

  shared_examples 'does not delete' do
    it { is_expected.to be_error }

    it 'does not delete flow' do
      expect { service_response }.not_to change { Flow.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'does not delete'
  end

  context 'when user does not have permission' do
    let(:current_user) { create(:user) }

    it_behaves_like 'does not delete'
  end

  context 'when user has permission' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :delete_flow, user: current_user, subject: namespace_project)
    end

    it { is_expected.to be_success }

    it 'deletes the flow' do
      expect { service_response }.to change { Flow.count }.by(-1)
    end

    it do
      is_expected.to create_audit_event(
        :flow_deleted,
        author_id: current_user.id,
        entity_type: 'Flow',
        entity_id: flow.id,
        details: {
          **flow.attributes.except('created_at', 'updated_at'),
        },
        target_id: flow.project.id,
        target_type: 'NamespaceProject'
      )
    end

    it 'queues job to update runtimes' do
      allow(DeleteFlowForProjectJob).to receive(:perform_later)

      service_response

      expect(DeleteFlowForProjectJob).to have_received(:perform_later).with(namespace_project.id, flow.id)
    end

    context 'when a node in the flow is the starting node of a sub-flow' do
      let(:owner_node) { create(:node_function, flow: flow) }
      let(:sub_flow_starting_node) { create(:node_function, flow: flow) }
      let(:node_parameter) do
        create(:node_parameter, node_function: owner_node, literal_value: nil, reference_value: nil)
      end
      let!(:sub_flow) { create(:sub_flow, node_parameter: node_parameter, starting_node: sub_flow_starting_node) }

      it { is_expected.to be_success }

      it 'deletes the flow along with the nested sub-flow' do
        expect { service_response }.to change { Flow.count }.by(-1)

        expect(SubFlow.exists?(sub_flow.id)).to be false
      end
    end
  end
end
