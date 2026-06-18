# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::GenerateFlowService do
  subject(:service_response) do
    described_class.new(
      current_authentication,
      project: project,
      prompt: prompt,
      model_identifier: model_identifier,
      flow: flow,
      client: client,
      cache: cache,
      config: { enabled: true }
    ).execute
  end

  let(:current_authentication) { instance_double(UserSession) }
  let(:project) { instance_double(NamespaceProject, id: 12, primary_runtime: runtime) }
  let(:runtime) do
    instance_double(
      Runtime,
      id: 9,
      function_definitions: [function_definition],
      data_types: [data_type],
      flow_types: [flow_type]
    )
  end
  let(:function_definition) { instance_double(FunctionDefinition, to_grpc: grpc_function_definition) }
  let(:data_type) { instance_double(DataType, to_grpc: grpc_data_type) }
  let(:flow_type) { instance_double(FlowType, to_grpc: grpc_flow_type) }
  let(:grpc_function_definition) { Tucana::Shared::FunctionDefinition.new(runtime_name: 'sum') }
  let(:grpc_data_type) { Tucana::Shared::DefinitionDataType.new(identifier: 'number') }
  let(:grpc_flow_type) { Tucana::Shared::FlowType.new(identifier: 'default') }
  let(:client) { instance_double(Sagittarius::Velorum::Client) }
  let(:prompt_requests) { [] }
  let(:flow_requests) { [] }
  let(:cache) { ActiveSupport::Cache::MemoryStore.new }
  let(:prompt) { 'Generate a flow' }
  let(:model_identifier) { 'gpt-5' }
  let(:flow) { nil }
  let(:cached_until) { 1_900_000_000_000 }
  let(:generated_flow) do
    Tucana::Shared::GenerationFlow.new(
      name: 'Generated flow',
      type: 'default',
      starting_node_id: '1',
      settings: [
        Tucana::Shared::FlowSetting.new(
          flow_setting_id: 'region',
          value: Tucana::Shared::Value.from_ruby('eu')
        )
      ],
      node_functions: [
        Tucana::Shared::NodeFunction.new(
          database_id: 1,
          runtime_function_id: 'sum',
          parameters: [
            Tucana::Shared::NodeParameter.new(
              runtime_parameter_id: 'left',
              value: Tucana::Shared::NodeValue.new(literal_value: Tucana::Shared::Value.from_ruby(1))
            )
          ]
        )
      ]
    )
  end
  let(:flow_response) do
    Tucana::Velorum::FlowResponse.new(
      flow: generated_flow,
      cached_until: cached_until,
      usage: 42
    )
  end

  before do
    allow(Time).to receive(:now).and_return(Time.zone.local(2026, 6, 12, 10, 0, 0))
    allow(Ability).to receive(:allowed?).and_return(true)
    allow(client).to receive(:prompt) do |request|
      prompt_requests << request
      flow_response
    end
    allow(client).to receive(:flow) do |request|
      flow_requests << request
      flow_response
    end
  end

  it 'sends available definitions with a prompt request when Velorum has no valid cache marker' do
    expect(service_response).to be_success

    expect(client).to have_received(:prompt) do |request|
      expect(request).to be_a(Tucana::Velorum::PromptRequest)
      expect(request.prompt).to eq(prompt)
      expect(request.project_id).to eq(project.id)
      expect(request.model_identifier).to eq(model_identifier)
      expect(request.functions).to eq([grpc_function_definition])
      expect(request.data_types).to eq([grpc_data_type])
      expect(request.flow_types).to eq([grpc_flow_type])
    end

    expect(service_response.payload).to include(cached_until: cached_until, usage: 42)
    expect(service_response.payload[:flow]).to include(
      name: 'Generated flow',
      type: 'default',
      starting_node_id: '1'
    )
  end

  it 'omits definitions while the Velorum cache marker is still valid' do
    service_response

    second_response = described_class.new(
      current_authentication,
      project: project,
      prompt: prompt,
      model_identifier: model_identifier,
      client: client,
      cache: cache,
      config: { enabled: true }
    ).execute

    expect(second_response).to be_success
    expect(prompt_requests.size).to eq(2)
    expect(prompt_requests.last.functions).to be_empty
    expect(prompt_requests.last.data_types).to be_empty
    expect(prompt_requests.last.flow_types).to be_empty
  end

  context 'with an existing flow' do
    let(:flow) do
      instance_double(
        Flow,
        project: project,
        to_generation_grpc: Tucana::Shared::GenerationFlow.new(name: 'Existing flow')
      )
    end

    it 'uses the Velorum Flow RPC and checks update permissions' do
      expect(service_response).to be_success

      expect(Ability).to have_received(:allowed?).with(current_authentication, :update_flow, flow)
      expect(client).to have_received(:flow) do |request|
        expect(request).to be_a(Tucana::Velorum::FlowRequest)
        expect(request.flow.name).to eq('Existing flow')
      end
    end
  end

  context 'when the project does not have a primary runtime' do
    let(:runtime) { nil }

    it 'returns an error response' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:no_primary_runtime)
      expect(client).not_to have_received(:prompt)
    end
  end

  context 'when Velorum returns a gRPC error' do
    before do
      allow(client).to receive(:prompt).and_raise(
        GRPC::BadStatus.new_status_exception(GRPC::Core::StatusCodes::INTERNAL, 'Unexpected generation error')
      )
    end

    it 'returns an error response' do
      expect(service_response).to be_error
      expect(service_response.message).to eq('Flow generation failed')
      expect(service_response.payload[:error_code]).to eq(:flow_generation_failed)
      expect(service_response.payload[:details]).to include(
        grpc_code: GRPC::Core::StatusCodes::INTERNAL,
        grpc_details: 'Unexpected generation error'
      )
    end
  end

  context 'when Velorum is disabled' do
    subject(:service_response) do
      described_class.new(
        current_authentication,
        project: project,
        prompt: prompt,
        model_identifier: model_identifier,
        client: client,
        cache: cache,
        config: { enabled: false }
      ).execute
    end

    it 'returns an error without calling Velorum' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:invalid_setting)
      expect(client).not_to have_received(:prompt)
      expect(client).not_to have_received(:flow)
    end
  end
end
