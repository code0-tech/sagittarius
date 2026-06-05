# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::PersistExecutionResultService do
  subject(:service_response) { described_class.new(grpc_result).execute }

  let(:flow) { create(:flow) }
  let(:node_function) { create(:node_function, flow: flow) }
  let(:started_at) { 1_780_430_000_000 }
  let(:finished_at) { 1_780_430_002_000 }

  let(:grpc_result) do
    Tucana::Shared::ExecutionResult.new(
      execution_identifier: 'execution-identifier',
      flow_id: flow.id,
      started_at: started_at,
      finished_at: finished_at,
      input: Tucana::Shared::Value.from_ruby('input' => 'value'),
      success: Tucana::Shared::Value.from_ruby('result' => true),
      node_execution_results: [
        Tucana::Shared::NodeExecutionResult.new(
          node_id: node_function.id,
          started_at: started_at,
          finished_at: finished_at,
          success: Tucana::Shared::Value.from_ruby('node' => 'ok'),
          parameter_results: [
            Tucana::Shared::NodeParameterNodeExecutionResult.new(
              value: Tucana::Shared::Value.from_ruby('parameter' => 1)
            )
          ]
        )
      ]
    )
  end

  before do
    allow(SubscriptionTriggers).to receive(:execution_result)
  end

  it { is_expected.to be_success }

  it 'persists the execution result and nested node results' do
    expect { service_response }
      .to change { ExecutionResult.count }.by(1)
      .and change { ExecutionNodeResult.count }.by(1)
      .and change { ExecutionParameterResult.count }.by(1)

    execution_result = service_response.payload
    expect(execution_result).to have_attributes(
      flow: flow,
      execution_identifier: 'execution-identifier',
      input: { 'input' => 'value' },
      success: { 'result' => true },
      error: nil,
      started_at: Time.zone.at(0, started_at, :millisecond),
      finished_at: Time.zone.at(0, finished_at, :millisecond)
    )

    node_result = execution_result.node_results.sole
    expect(node_result).to have_attributes(
      node_function: node_function,
      position: 0,
      success: { 'node' => 'ok' },
      error: nil
    )

    expect(node_result.parameter_results.sole).to have_attributes(
      position: 0,
      value: { 'parameter' => 1 }
    )
  end

  it 'triggers the execution result subscription' do
    service_response

    expect(SubscriptionTriggers).to have_received(:execution_result).with(service_response.payload)
  end

  context 'when the result is an error' do
    let(:grpc_result) do
      Tucana::Shared::ExecutionResult.new(
        execution_identifier: 'execution-identifier',
        flow_id: flow.id,
        started_at: started_at,
        finished_at: finished_at,
        input: Tucana::Shared::Value.from_ruby(nil),
        error: Tucana::Shared::Error.new(
          code: 'FAILED',
          category: 'runtime',
          message: 'Execution failed',
          timestamp: 123,
          version: '1.0.0',
          dependencies: { 'dep' => '1.2.3' },
          details: Tucana::Shared::Struct.from_hash('reason' => 'bad-input')
        )
      )
    end

    it 'persists runtime errors as JSON' do
      expect(service_response.payload.error).to eq(
        'code' => 'FAILED',
        'category' => 'runtime',
        'message' => 'Execution failed',
        'timestamp' => 123,
        'version' => '1.0.0',
        'dependencies' => { 'dep' => '1.2.3' },
        'details' => { 'reason' => 'bad-input' }
      )
    end
  end

  context 'when the flow is missing' do
    let(:grpc_result) do
      Tucana::Shared::ExecutionResult.new(
        execution_identifier: 'execution-identifier',
        flow_id: flow.id,
        started_at: started_at,
        finished_at: finished_at,
        success: Tucana::Shared::Value.from_ruby('result' => true)
      )
    end

    before do
      flow.destroy!
    end

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:flow_not_found)
    end
  end

  context 'when the execution result is invalid' do
    before do
      create(:execution_result, flow: flow, execution_identifier: 'execution-identifier')
    end

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:invalid_execution_result)
    end
  end
end
