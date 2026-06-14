# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VelorumGenerateFlowJob do
  include ActiveJob::TestHelper

  let(:id) { SecureRandom.uuid }
  let(:project) { create(:namespace_project, primary_runtime: create(:runtime)) }
  let(:service) { instance_double(Velorum::GenerateFlowService, execute: service_response) }
  let(:flow) { { name: 'Generated flow', type: 'default', nodes: [] } }
  let(:service_response) { ServiceResponse.success(payload: { flow: flow }) }

  before do
    allow(Velorum::GenerateFlowService).to receive(:new).and_return(service)
    allow(SubscriptionTriggers).to receive(:velorum_generate_flow)
  end

  it 'calls Velorum in the background and triggers the subscription response' do
    perform_enqueued_jobs do
      described_class.perform_later(id, project.id, 'Generate a flow', 'gpt-5')
    end

    expect(Velorum::GenerateFlowService).to have_received(:new).with(
      nil,
      project: project,
      prompt: 'Generate a flow',
      model_identifier: 'gpt-5',
      flow: nil,
      authorize: false
    )
    expect(SubscriptionTriggers).to have_received(:velorum_generate_flow).with(id, flow)
  end

  it 'does not trigger the subscription when the project is gone' do
    perform_enqueued_jobs do
      described_class.perform_later(id, -1, 'Generate a flow', 'gpt-5')
    end

    expect(Velorum::GenerateFlowService).not_to have_received(:new)
    expect(SubscriptionTriggers).not_to have_received(:velorum_generate_flow)
  end
end
