# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteFlowForProjectJob do
  include ActiveJob::TestHelper

  it 'sends the deleted flow id' do
    project = create(:namespace_project)
    flow_id = 123
    allow(FlowHandler).to receive(:delete_flow)

    perform_enqueued_jobs { described_class.perform_later(project.id, flow_id) }

    expect(FlowHandler).to have_received(:delete_flow).with(project, flow_id)
  end
end
