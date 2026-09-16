# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnforceRuntimeUsageLimitJob do
  include ActiveJob::TestHelper

  describe '.enqueue_for' do
    it 'schedules the job with the configured delay' do
      flow = create(:flow)

      described_class.enqueue_for(flow)

      job = enqueued_jobs.find { |enqueued| enqueued[:job] == described_class }
      expect(job[:args].first).to eq(flow.id)
      expect(job[:at]).to be_within(1.second).of((Time.current + described_class::DELAY).to_f)
    end
  end

  describe '#perform' do
    it 'delegates to EnforceUsageLimitService for the flow' do
      flow = create(:flow)
      service = instance_double(Namespaces::Projects::Flows::EnforceUsageLimitService, execute: nil)
      allow(Namespaces::Projects::Flows::EnforceUsageLimitService).to receive(:new).with(flow).and_return(service)

      perform_enqueued_jobs { described_class.perform_later(flow.id) }

      expect(service).to have_received(:execute)
    end

    it 'does nothing if the flow no longer exists' do
      expect { described_class.new.perform(0) }.not_to raise_error
    end
  end

  describe '.concurrency_key_for' do
    it "delegates to the enforcement service's concurrency scope key" do
      flow = create(:flow)
      allow(Namespaces::Projects::Flows::EnforceUsageLimitService).to receive(:concurrency_scope_key)
        .with(flow).and_return('some-scope')

      expect(described_class.concurrency_key_for(flow.id)).to eq('enforce_runtime_usage_limit-some-scope')
    end

    it 'falls back to a per-flow key if the flow no longer exists' do
      expect(described_class.concurrency_key_for(0)).to eq('enforce_runtime_usage_limit-flow-0')
    end
  end

  describe 'concurrency' do
    it 'limits concurrency to one in-flight job per scope key' do
      expect(described_class.good_job_concurrency_config).to include(total_limit: 1)
    end
  end
end
