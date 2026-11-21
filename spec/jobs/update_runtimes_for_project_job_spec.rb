# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateRuntimesForProjectJob do
  include ActiveJob::TestHelper

  let(:flow) { create(:flow) }
  let(:runtimes) { create_list(:runtime, 2, namespace: flow.namespace_project.namespace) }
  let!(:other_runtime) { create(:runtime, namespace: flow.namespace_project.namespace) }

  before do
    runtimes.each do |runtime|
      create(:namespace_project_runtime_assignment, namespace_project: flow.namespace_project, runtime: runtime)
    end
  end

  it 'sends update to all relevant runtimes' do
    allow(FlowHandler).to receive(:update_runtime)

    perform_enqueued_jobs do
      described_class.perform_later(flow.namespace_project.id)
    end

    runtimes.each do |runtime|
      expect(FlowHandler).to have_received(:update_runtime).with(runtime)
    end

    expect(FlowHandler).not_to have_received(:update_runtime).with(other_runtime)
  end
end
