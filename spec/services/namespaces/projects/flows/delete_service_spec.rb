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
      stub_allowed_ability(NamespaceProjectPolicy, :delete_flows, user: current_user, subject: namespace_project)
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
  end
end
