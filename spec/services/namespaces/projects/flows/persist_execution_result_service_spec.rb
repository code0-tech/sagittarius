# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::PersistExecutionResultService do
  subject(:service_response) { described_class.new(grpc_result).execute }

  let(:flow) { create(:flow) }
  let(:node_function) { create(:node_function, flow: flow) }
  let(:started_at) { 1_780_430_000_000_000 }
  let(:finished_at) { 1_780_430_002_000_000 }

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
      started_at: started_at,
      finished_at: finished_at
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

  context 'when a parameter result is an empty struct' do
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
                value: Tucana::Shared::Value.from_ruby({})
              )
            ]
          )
        ]
      )
    end

    it 'persists the empty object as a valid JSON value' do
      expect(service_response).to be_success
      expect(service_response.payload.node_results.sole.parameter_results.sole.value).to eq({})
    end
  end

  context 'when a parameter result value is JSON null' do
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
                value: Tucana::Shared::Value.from_ruby(nil)
              )
            ]
          )
        ]
      )
    end

    it 'persists the null parameter result' do
      expect(service_response).to be_success
      expect(service_response.payload.node_results.sole.parameter_results.sole.value).to be_nil
    end
  end

  context 'when the execution result success is JSON null' do
    let(:grpc_result) do
      Tucana::Shared::ExecutionResult.new(
        execution_identifier: 'execution-identifier',
        flow_id: flow.id,
        started_at: started_at,
        finished_at: finished_at,
        input: Tucana::Shared::Value.from_ruby('input' => 'value'),
        success: Tucana::Shared::Value.from_ruby(nil),
        node_execution_results: [
          Tucana::Shared::NodeExecutionResult.new(
            node_id: node_function.id,
            started_at: started_at,
            finished_at: finished_at,
            success: Tucana::Shared::Value.from_ruby(nil)
          )
        ]
      )
    end

    it 'persists null success values' do
      expect(service_response).to be_success
      expect(service_response.payload.success).to be_nil
      expect(service_response.payload.node_results.sole.success).to be_nil
    end
  end

  context 'when a node execution result targets a function definition' do
    let(:function_definition) { create(:function_definition) }

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
            function_identifier: function_definition.identifier,
            started_at: started_at,
            finished_at: finished_at,
            success: Tucana::Shared::Value.from_ruby('function' => 'ok')
          )
        ]
      )
    end

    before do
      flow.project.update!(primary_runtime: function_definition.runtime)
    end

    it 'persists the function definition as the execution target' do
      expect(service_response).to be_success

      expect(service_response.payload.node_results.sole).to have_attributes(
        node_function: nil,
        function_definition: function_definition,
        success: { 'function' => 'ok' }
      )
    end

    it 'ignores matching definitions from other runtimes' do
      expect(service_response).to be_success

      expect(service_response.payload.node_results.sole).to have_attributes(
        function_definition: function_definition
      )
    end
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

  context 'with subscription integration', type: :channel do
    include AuthenticationHelpers
    include ActionCable::Channel::TestCase::Behavior

    include_context 'with graphql subscription support'

    tests GraphqlChannel

    let(:user) { create(:user) }
    let(:token) { "Session #{authorization_token(user)}" }

    before do
      allow(SubscriptionTriggers).to receive(:execution_result).and_call_original

      create(:namespace_member, namespace: flow.project.namespace, user: user)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: user, subject: flow.project)

      subscribe(token: token)

      perform :execute,
              query: <<~GQL,
                subscription($executionIdentifier: String!) {
                  namespacesProjectsFlowsExecutionResult(executionIdentifier: $executionIdentifier) {
                    executionResult { success }
                  }
                }
              GQL
              variables: { executionIdentifier: 'execution-identifier' }
    end

    it 'delivers the execution result to subscribers without visibility profile error' do
      service_response

      result = transmissions.last
      expect(result.dig('result', 'data', 'namespacesProjectsFlowsExecutionResult', 'executionResult', 'success'))
        .to eq({ 'result' => true })
    end
  end
end
