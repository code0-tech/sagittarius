# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateRuntimeCompatibilityJob do
  include ActiveJob::TestHelper

  it 'calls the compatibility service for each assignment and updates compatible' do
    assignment1 = create(:namespace_project_runtime_assignment, compatible: false)
    assignment2 = create(:namespace_project_runtime_assignment, compatible: false)

    success_res = ServiceResponse.success
    err_response = ServiceResponse.error

    service1 = instance_double(Runtimes::CheckRuntimeCompatibilityService, execute: success_res)
    service2 = instance_double(Runtimes::CheckRuntimeCompatibilityService, execute: err_response)

    allow(Runtimes::CheckRuntimeCompatibilityService).to receive(:new)
      .with(assignment1.runtime, assignment1.namespace_project).and_return(service1)
    allow(Runtimes::CheckRuntimeCompatibilityService).to receive(:new)
      .with(assignment2.runtime, assignment2.namespace_project).and_return(service2)

    conditions = { id: [assignment1.id, assignment2.id] }

    perform_enqueued_jobs do
      described_class.perform_later(conditions)
    end

    expect(assignment1.reload.compatible).to be true
    expect(assignment2.reload.compatible).to be false
  end
end
