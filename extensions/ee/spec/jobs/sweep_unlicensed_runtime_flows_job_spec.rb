# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SweepUnlicensedRuntimeFlowsJob do
  include ActiveJob::TestHelper

  let(:gateway_client) { instance_double(Sagittarius::Gateway::Client, push_flow: nil) }

  before do
    allow(FlowHandler).to receive(:gateway_client).and_return(gateway_client)
  end

  context 'when no active license exists' do
    it 'pushes an empty flow list to every connected runtime' do
      running_runtime = create(:runtime)
      running_runtime.runtime_status.record_status!(status: :running)
      not_responding_runtime = create(:runtime)
      not_responding_runtime.runtime_status.record_status!(status: :not_responding)

      perform_enqueued_jobs { described_class.perform_later }

      expect(gateway_client).to have_received(:push_flow).once do |runtime_id, response|
        expect(runtime_id).to eq(running_runtime.id)
        expect(response.flows.flows).to be_empty
      end
    end
  end

  context 'when an active license exists' do
    it 'does not push any flow updates' do
      create(:license)
      runtime = create(:runtime)
      runtime.runtime_status.record_status!(status: :running)

      perform_enqueued_jobs { described_class.perform_later }

      expect(gateway_client).not_to have_received(:push_flow)
    end
  end
end
