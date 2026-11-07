# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::EnforceUsageLimitService do
  include ActiveSupport::Testing::TimeHelpers

  # Both the ee and cloud extensions are active in this test environment, and Cloud overrides
  # every hook this service exposes (license/limit/cycle_anchor/scope). Exercising the real
  # `Namespaces::Projects::Flows::EnforceUsageLimitService` here would test Cloud's behavior, not
  # EE's - so, same as EE::FlowHandler's spec, build an isolated class that only has EE's module
  # prepended, mirroring the core class's shape.
  subject(:service_response) { isolated_service_class.new(flow).execute }

  let(:isolated_service_class) do
    Class.new do
      attr_reader :flow

      def initialize(flow = nil, namespace: nil)
        @flow = flow
        @namespace = namespace
      end

      def execute
        ServiceResponse.success(message: 'No usage limit enforcement configured')
      end

      prepend EE::Namespaces::Projects::Flows::EnforceUsageLimitService
    end
  end

  let(:flow) { create(:flow) }

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

  it { expect(described_class).to include_module(EE::Namespaces::Projects::Flows::EnforceUsageLimitService) }

  context 'without an active license' do
    it 'disables the flow on its very first execution (strict 0 limit)' do
      record_usage(flow, 1)

      expect(service_response).to be_success
      expect(flow.reload).to have_attributes(disabled_reason: 'usage_limit_exceeded')
      expect(FlowHandler).to have_received(:update_flow).with(flow)
    end

    it 'disables every enabled flow installation-wide, not just the triggering one' do
      other_flow = create(:flow)
      record_usage(flow, 1)

      service_response

      expect(other_flow.reload).to have_attributes(disabled_reason: 'usage_limit_exceeded')
    end
  end

  context 'with a license that has no workflow_executions restriction' do
    before { create(:license, restrictions: {}) }

    it 'never disables flows, regardless of usage' do
      record_usage(flow, 10_000)

      expect(service_response).to be_success
      expect(flow.reload.disabled?).to be(false)
    end
  end

  context 'with a license restricting workflow_executions' do
    before { create(:license, start_date: Date.new(2026, 1, 15), restrictions: { workflow_executions: 5 }) }

    it 'does not disable flows while usage is within the limit' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 5) }

      travel_to(Date.new(2026, 9, 16)) { service_response }

      expect(flow.reload.disabled?).to be(false)
    end

    it 'disables flows once usage exceeds the limit, anchored to the license start_date cycle' do
      travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 6) }

      travel_to(Date.new(2026, 9, 16)) { service_response }

      expect(flow.reload).to have_attributes(
        disabled_reason: 'usage_limit_exceeded',
        disabled_until: Date.new(2026, 10, 15)
      )
    end

    it 'does not count usage from a previous billing cycle' do
      travel_to(Date.new(2026, 8, 20)) { record_usage(flow, 6) }

      travel_to(Date.new(2026, 9, 16)) { service_response }

      expect(flow.reload.disabled?).to be(false)
    end
  end

  context 'when a flow is already disabled for the same reason' do
    before { create(:license, restrictions: { workflow_executions: 0 }) }

    it 'is idempotent' do
      flow.update!(disabled_reason: :usage_limit_exceeded, disabled_until: Date.tomorrow)
      record_usage(flow, 1)

      expect { service_response }.not_to raise_error
      expect(flow.reload.disabled_reason).to eq('usage_limit_exceeded')
    end
  end

  describe '#reenable_flows' do
    subject(:reenable_response) { isolated_service_class.new.reenable_flows }

    let!(:flow) do
      create(:flow, disabled_reason: :usage_limit_exceeded, disabled_until: Date.new(2026, 10, 15))
    end

    context 'with a license restricting workflow_executions' do
      before { create(:license, start_date: Date.new(2026, 1, 15), restrictions: { workflow_executions: 5 }) }

      it 're-enables usage-limit-disabled flows installation-wide once usage is within the limit' do
        other_flow = create(:flow, disabled_reason: :usage_limit_exceeded, disabled_until: Date.new(2026, 10, 15))
        travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 5) }

        travel_to(Date.new(2026, 9, 16)) { expect(reenable_response).to be_success }

        expect(flow.reload.disabled?).to be(false)
        expect(other_flow.reload.disabled?).to be(false)
        expect(FlowHandler).to have_received(:update_flow).with(flow)
      end

      it 'keeps flows disabled while usage still exceeds the limit' do
        travel_to(Date.new(2026, 9, 16)) { record_usage(flow, 6) }

        travel_to(Date.new(2026, 9, 16)) { reenable_response }

        expect(flow.reload).to have_attributes(disabled_reason: 'usage_limit_exceeded')
        expect(FlowHandler).not_to have_received(:update_flow)
      end
    end

    context 'without an active license' do
      it 're-enables flows when there is no usage against the strict 0 limit' do
        expect(reenable_response).to be_success
        expect(flow.reload.disabled?).to be(false)
      end

      it 'keeps flows disabled while any usage exists' do
        record_usage(flow, 1)

        reenable_response

        expect(flow.reload.disabled?).to be(true)
      end
    end
  end
end
