# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::TriggerExecutionService do
  subject(:service_response) do
    described_class.new(
      create_authentication(current_user),
      flow: flow,
      runtime: runtime,
      input: input
    ).execute
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow) { create(:flow, project: project) }
  let(:input) { { 'value' => 42 } }

  before do
    allow(ExecutionHandler).to receive(:send_execution_request)
  end

  context 'when user cannot trigger execution' do
    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:missing_permission)
      expect(ExecutionHandler).not_to have_received(:send_execution_request)
    end
  end

  context 'when user can trigger execution' do
    before do
      namespace_role = create(:namespace_role, namespace: project.namespace)
      namespace_member = create(:namespace_member, namespace: project.namespace, user: current_user)

      create(:namespace_role_ability, namespace_role: namespace_role, ability: :read_namespace_project)
      create(:namespace_member_role, role: namespace_role, member: namespace_member)
    end

    it { is_expected.to be_success }

    it 'sends a test execution request to the selected runtime' do
      service_response

      expect(ExecutionHandler).to have_received(:send_execution_request) do |runtime_id, request|
        expect(runtime_id).to eq(runtime.id)
        expect(request).to be_a(Tucana::Sagittarius::TestExecutionRequest)
        expect(request.flow_id).to eq(flow.id)
        expect(request.execution_identifier).to eq(service_response.payload)
        expect(request.body.to_ruby(true)).to eq(input)
      end
    end
  end
end
