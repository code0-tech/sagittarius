# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowValidationJob do
  include ActiveJob::TestHelper

  let(:flow) { create(:flow) }

  it 'calls the validation service' do
    service = instance_double(Namespaces::Projects::Flows::ValidationService)
    allow(Namespaces::Projects::Flows::ValidationService).to receive(:new).with(flow).and_return(service)
    allow(service).to receive(:execute)

    perform_enqueued_jobs do
      described_class.perform_later(flow.id)
    end

    expect(service).to have_received(:execute)
  end

  it 'does not raise when flow does not exist' do
    expect do
      perform_enqueued_jobs do
        described_class.perform_later(-1)
      end
    end.not_to raise_error
  end
end
