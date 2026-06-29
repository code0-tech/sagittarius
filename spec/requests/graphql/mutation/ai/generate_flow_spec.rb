# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'aiGenerateFlow Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~GQL
      mutation($input: AiGenerateFlowInput!) {
        aiGenerateFlow(input: $input) {
          executionIdentifier
          #{error_query}
        }
      }
    GQL
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:runtime_module) { create(:runtime_module, runtime: runtime) }
  let(:runtime_function_definition) do
    create(:runtime_function_definition, runtime: runtime, runtime_module: runtime_module)
  end
  let(:runtime_flow_type) { create(:runtime_flow_type, runtime: runtime, runtime_module: runtime_module) }
  let!(:function_definition) do
    create(
      :function_definition,
      runtime: runtime,
      runtime_module: runtime_module,
      runtime_function_definition: runtime_function_definition
    )
  end
  let!(:flow_type) do
    create(
      :flow_type,
      runtime: runtime,
      runtime_module: runtime_module,
      runtime_flow_type: runtime_flow_type
    )
  end
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:variables) do
    {
      input: {
        projectId: project.to_global_id.to_s,
        prompt: 'Generate a flow',
        modelIdentifier: 'gpt-5',
      },
    }
  end

  before do
    allow(Sagittarius::Configuration).to receive(:config)
      .and_return(velorum: { enabled: true })
    allow(VelorumGenerateFlowJob).to receive(:perform_later)

    create(:namespace_member, namespace: project.namespace, user: current_user)
    stub_allowed_ability(NamespaceProjectPolicy, :create_flow, user: current_user, subject: project)
  end

  it 'returns an execution identifier and enqueues the Velorum generation job' do
    mutate!

    execution_identifier = graphql_data_at(:ai_generate_flow, :execution_identifier)
    expect(execution_identifier).to be_present
    expect(graphql_data_at(:ai_generate_flow, :errors)).to eq([])
    expect(VelorumGenerateFlowJob).to have_received(:perform_later).with(
      execution_identifier,
      project.id,
      'Generate a flow',
      'gpt-5',
      nil
    )
  end

  context 'when AI is disabled' do
    before do
      allow(Sagittarius::Configuration).to receive(:config)
        .and_return(velorum: { enabled: false })
    end

    it 'returns an error and does not enqueue a job' do
      mutate!

      expect(graphql_data_at(:ai_generate_flow, :execution_identifier)).to be_nil
      expect(graphql_data_at(:ai_generate_flow, :errors, 0, :error_code)).to eq('INVALID_SETTING')
      expect(VelorumGenerateFlowJob).not_to have_received(:perform_later)
    end
  end

  context 'when the prompt is blank' do
    before { variables[:input][:prompt] = ' ' }

    it 'returns an error and does not enqueue a job' do
      mutate!

      expect(graphql_data_at(:ai_generate_flow, :execution_identifier)).to be_nil
      expect(graphql_data_at(:ai_generate_flow, :errors, 0, :error_code)).to eq('MISSING_PARAMETER')
      expect(VelorumGenerateFlowJob).not_to have_received(:perform_later)
    end
  end

  context 'when the model identifier is blank' do
    before { variables[:input][:modelIdentifier] = ' ' }

    it 'returns an error and does not enqueue a job' do
      mutate!

      expect(graphql_data_at(:ai_generate_flow, :execution_identifier)).to be_nil
      expect(graphql_data_at(:ai_generate_flow, :errors, 0, :error_code)).to eq('MISSING_PARAMETER')
      expect(VelorumGenerateFlowJob).not_to have_received(:perform_later)
    end
  end

  context 'when the primary runtime has no functions' do
    before { function_definition.destroy! }

    it 'returns an error and does not enqueue a job' do
      mutate!

      expect(graphql_data_at(:ai_generate_flow, :execution_identifier)).to be_nil
      expect(graphql_data_at(:ai_generate_flow, :errors, 0, :error_code)).to eq('NO_DEFINITIONS')
      expect(VelorumGenerateFlowJob).not_to have_received(:perform_later)
    end
  end

  context 'when the primary runtime has no flow types' do
    before { flow_type.destroy! }

    it 'returns an error and does not enqueue a job' do
      mutate!

      expect(graphql_data_at(:ai_generate_flow, :execution_identifier)).to be_nil
      expect(graphql_data_at(:ai_generate_flow, :errors, 0, :error_code)).to eq('NO_DEFINITIONS')
      expect(VelorumGenerateFlowJob).not_to have_received(:perform_later)
    end
  end
end
