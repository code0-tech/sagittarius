# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetExpiredFlowDisablesJob do
  before do
    allow(FlowHandler).to receive(:update_flow)
  end

  it 're-enables a flow whose disabled_until has passed and pushes the update' do
    flow = create(:flow, disabled_reason: :usage_limit_exceeded, disabled_until: Date.yesterday)

    described_class.new.perform

    expect(flow.reload).to have_attributes(disabled_reason: nil, disabled_until: nil)
    expect(FlowHandler).to have_received(:update_flow).with(flow)
  end

  it 'leaves a flow disabled if disabled_until is still in the future' do
    flow = create(:flow, disabled_reason: :usage_limit_exceeded, disabled_until: Date.tomorrow)

    described_class.new.perform

    expect(flow.reload).to have_attributes(disabled_reason: 'usage_limit_exceeded', disabled_until: Date.tomorrow)
    expect(FlowHandler).not_to have_received(:update_flow)
  end

  it 'ignores enabled flows' do
    create(:flow)

    expect { described_class.new.perform }.not_to raise_error
    expect(FlowHandler).not_to have_received(:update_flow)
  end
end
