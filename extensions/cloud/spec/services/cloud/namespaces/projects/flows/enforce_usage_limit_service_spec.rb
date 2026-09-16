# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::EnforceUsageLimitService do
  include ActiveSupport::Testing::TimeHelpers

  subject(:service_response) { described_class.new(flow).execute }

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:flow) { create(:flow, project: project) }

  before do
    allow(FlowHandler).to receive(:update_flow)
  end

  def record_usage(for_flow, count, date: Date.current)
    count.times do
      RuntimeUsageDailyAggregate.record_execution!(
        flow_id: for_flow.id, project_id: for_flow.project.id, namespace_id: for_flow.project.namespace_id,
        date: date, execution_time_us: 1, unique_by: %i[flow_id date]
      )
    end
  end

  it { expect(described_class).to include_module(CLOUD::Namespaces::Projects::Flows::EnforceUsageLimitService) }

  describe '.concurrency_scope_key' do
    it 'is shared by every flow in the namespace' do
      other_project_flow = create(:flow, project: create(:namespace_project, namespace: namespace))

      expect(described_class.concurrency_scope_key(flow))
        .to eq(described_class.concurrency_scope_key(other_project_flow))
      expect(described_class.concurrency_scope_key(flow)).to eq("namespace-#{namespace.id}")
    end
  end

  context 'without a namespace license' do
    it 'defaults to a limit of 50, anchored to the namespace creation date' do
      travel_to(namespace.created_at + 10.days) { record_usage(flow, 50) }

      response = travel_to(namespace.created_at + 10.days) { service_response }

      expect(response).to be_success
      expect(flow.reload.disabled?).to be(false)
    end

    it 'disables namespace flows once usage exceeds 50 for the cycle' do
      travel_to(namespace.created_at + 10.days) { record_usage(flow, 51) }

      travel_to(namespace.created_at + 10.days) { service_response }

      expect(flow.reload).to have_attributes(disabled_reason: 'usage_limit_exceeded')
    end

    it 'only counts and disables flows within the same namespace' do
      other_namespace_flow = create(:flow)
      record_usage(flow, 51)
      record_usage(other_namespace_flow, 51)

      service_response

      expect(flow.reload.disabled?).to be(true)
      expect(other_namespace_flow.reload.disabled?).to be(false)
    end
  end

  context 'with a namespace license restricting workflow_executions' do
    before do
      create(:license, namespace: namespace, start_date: Date.new(2026, 1, 15),
                       restrictions: { workflow_executions: 5 })
    end

    it 'uses the license limit instead of the unlicensed default of 50' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 6) }

      travel_to(Date.new(2026, 9, 16)) { service_response }

      expect(flow.reload).to have_attributes(
        disabled_reason: 'usage_limit_exceeded',
        disabled_until: Date.new(2026, 10, 15)
      )
    end

    it 'does not disable while usage is within the licensed limit' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 5) }

      travel_to(Date.new(2026, 9, 16)) { service_response }

      expect(flow.reload.disabled?).to be(false)
    end
  end
end
