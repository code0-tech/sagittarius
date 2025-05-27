# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::UpdateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow: flow, **params).execute }

  let(:namespace_project) { create(:namespace_project) }
  let(:starting_node) { create(:node_function) }
  let(:flow_type) { create(:flow_type) }
  let(:flow) { create(:flow, project: namespace_project, flow_type: flow_type, starting_node: starting_node) }
  let(:new_starting_node) { create(:node_function) }
  let(:params) { { starting_node: new_starting_node } }

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it 'does not update flow' do
      expect { service_response }.not_to change { flow.reload.starting_node_id }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'does not update'
  end

  context 'when user does not have permission' do
    let(:current_user) { create(:user) }

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }
    let(:params) { { starting_node: nil } } # Invalid params

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flows, user: current_user, subject: namespace_project)
    end

    it_behaves_like 'does not update'
  end

  context 'when user has permission and params are valid' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flows, user: current_user, subject: namespace_project)
    end

    it { is_expected.to be_success }

    it 'updates the flow' do
      expect { service_response }.to change { flow.reload.starting_node_id }.to(new_starting_node.id)
    end

    it do
      old_attributes = flow.attributes.except('created_at', 'updated_at')

      is_expected.to create_audit_event(
        :flow_updated,
        author_id: current_user.id,
        entity_type: 'Flow',
        entity_id: flow.id,
        details: {
          old_flow: old_attributes,
          new_flow: flow.reload.attributes.except('created_at', 'updated_at'),
        },
        target_id: flow.project.id,
        target_type: 'NamespaceProject'
      )
    end
  end
end
