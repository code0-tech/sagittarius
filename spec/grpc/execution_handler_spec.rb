# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExecutionHandler do
  describe '.send_execution_request' do
    it 'pushes a test execution request to the gateway for the runtime' do
      request = Tucana::Sagittarius::Gateway::TestExecutionRequest.new(
        flow_id: 1,
        execution_identifier: 'execution-identifier',
        body: Tucana::Shared::Value.from_ruby('input')
      )
      gateway_client = instance_double(Sagittarius::Gateway::Client, push_execution: nil)
      allow(described_class).to receive(:gateway_client).and_return(gateway_client)

      described_class.send_execution_request(123, request)

      expect(gateway_client).to have_received(:push_execution).with(123, request)
    end
  end

  describe '#update' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project, primary_runtime: runtime) }
    let(:flow) { create(:flow, project: project) }
    let(:started_at) { 1_780_430_000_000_000 }
    let(:finished_at) { 1_780_430_002_000_000 }

    let(:execution_result) do
      Tucana::Shared::ExecutionResult.new(
        execution_identifier: 'execution-identifier',
        flow_id: flow.id,
        started_at: started_at,
        finished_at: finished_at,
        input: Tucana::Shared::Value.from_ruby('input' => 'value'),
        success: Tucana::Shared::Value.from_ruby('result' => true)
      )
    end

    let(:request) { Tucana::Sagittarius::Rails::ExecutionRequest.new(response: execution_result) }

    before do
      create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project)
      allow(SubscriptionTriggers).to receive(:execution_result)
    end

    it 'persists the execution result and returns a successful response' do
      response = Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.update(request, nil)
      end

      expect(response).to be_a(Tucana::Sagittarius::Rails::ExecutionResponse)
      expect(response.success).to be(true)
      expect(ExecutionResult.last.execution_identifier).to eq('execution-identifier')
    end

    context 'when the flow cannot be found' do
      let(:request) do
        Tucana::Sagittarius::Rails::ExecutionRequest.new(
          response: Tucana::Shared::ExecutionResult.new(
            execution_identifier: 'execution-identifier',
            flow_id: flow.id + 1_000_000,
            started_at: started_at,
            finished_at: finished_at
          )
        )
      end

      it 'returns an unsuccessful response' do
        response = Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
          described_class.new.update(request, nil)
        end

        expect(response.success).to be(false)
      end
    end
  end
end
