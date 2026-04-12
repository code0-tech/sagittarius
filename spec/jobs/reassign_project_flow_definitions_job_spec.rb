# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReassignProjectFlowDefinitionsJob do
  include ActiveJob::TestHelper

  let(:project) { create(:namespace_project) }

  it 'calls ReassignFlowDefinitionsToRuntimeService with the project and its primary runtime' do
    service = instance_double(Namespaces::Projects::ReassignFlowDefinitionsToRuntimeService)
    allow(Namespaces::Projects::ReassignFlowDefinitionsToRuntimeService)
      .to receive(:new).with(project, project.primary_runtime).and_return(service)
    allow(service).to receive(:execute)

    perform_enqueued_jobs do
      described_class.perform_later(project.id)
    end

    expect(service).to have_received(:execute)
  end

  it 'does not raise when project does not exist' do
    expect do
      perform_enqueued_jobs do
        described_class.perform_later(-1)
      end
    end.not_to raise_error
  end
end
