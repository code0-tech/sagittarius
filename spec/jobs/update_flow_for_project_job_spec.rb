# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateFlowForProjectJob do
  include ActiveJob::TestHelper

  let(:flow) { create(:flow) }

  before do
    allow(FlowHandler).to receive(:update_flow)
    allow(FlowHandler).to receive(:delete_flow)
  end

  it 'sends a valid flow update' do
    flow.update!(validation_status: :valid)

    perform_enqueued_jobs { described_class.perform_later(flow.id) }

    expect(FlowHandler).to have_received(:update_flow).with(flow)
    expect(FlowHandler).not_to have_received(:delete_flow)
  end

  it 'does not send a deletion for a newly created invalid flow' do
    flow.update!(validation_status: :invalid)

    perform_enqueued_jobs { described_class.perform_later(flow.id) }

    expect(FlowHandler).not_to have_received(:delete_flow)
    expect(FlowHandler).not_to have_received(:update_flow)
  end
end
