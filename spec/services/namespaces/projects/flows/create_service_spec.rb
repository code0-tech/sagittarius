# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::CreateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), namespace_project: namespace_project, **params).execute
  end

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:starting_node) do
    create(:node_function, runtime_function: create(:runtime_function_definition, runtime: runtime))
  end
  let(:params) do
    { project: namespace_project, flow_type: create(:flow_type, runtime: runtime), starting_node: starting_node }
  end

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create flow' do
      expect { service_response }.not_to change { Flow.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when starting node is nil' do
      let(:params) { { project: namespace_project, flow_type: create(:flow_type), starting_node: nil } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespaceProjectPolicy, :create_flows, user: current_user, subject: namespace_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :flow_created,
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
  end
end
