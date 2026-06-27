# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VelorumGenerateFlowJob do
  include ActiveJob::TestHelper

  let(:execution_identifier) { SecureRandom.uuid }
  let(:project) { create(:namespace_project, primary_runtime: create(:runtime)) }
  let(:service) { instance_double(Velorum::GenerateFlowService, execute: service_response) }
  let(:flow) { { name: 'Generated flow', type: 'default', nodes: [] } }
  let(:service_response) { ServiceResponse.success(payload: { flow: flow }) }

  before do
    allow(Velorum::GenerateFlowService).to receive(:new).and_return(service)
    allow(SubscriptionTriggers).to receive(:ai_generate_flow)
  end

  it 'calls Velorum in the background and triggers the subscription response' do
    perform_enqueued_jobs do
      described_class.perform_later(execution_identifier, project.id, 'Generate a flow', 'gpt-5')
    end

    expect(Velorum::GenerateFlowService).to have_received(:new).with(
      nil,
      project: project,
      prompt: 'Generate a flow',
      model_identifier: 'gpt-5',
      flow: nil,
      authorize: false
    )
    expect(SubscriptionTriggers).to have_received(:ai_generate_flow).with(execution_identifier, flow)
  end

  it 'closes the subscription with an error when the project is gone' do
    perform_enqueued_jobs do
      described_class.perform_later(execution_identifier, -1, 'Generate a flow', 'gpt-5')
    end

    expect(Velorum::GenerateFlowService).not_to have_received(:new)
    expect(SubscriptionTriggers).to have_received(:ai_generate_flow).with(
      execution_identifier,
      nil,
      errors: [
        a_hash_including(
          error_code: :project_not_found,
          details: [{ message: 'Project does not exist' }]
        )
      ]
    )
  end

  context 'when flow generation fails' do
    let(:service_response) do
      ServiceResponse.error(message: 'Flow generation failed', error_code: :flow_generation_failed)
    end

    it 'triggers an error subscription response to close the stream' do
      perform_enqueued_jobs do
        described_class.perform_later(execution_identifier, project.id, 'Generate a flow', 'gpt-5')
      end

      expect(SubscriptionTriggers).to have_received(:ai_generate_flow).with(
        execution_identifier,
        nil,
        errors: [
          a_hash_including(
            error_code: :flow_generation_failed,
            details: [{ message: 'Flow generation failed' }]
          )
        ]
      )
    end
  end
end
