# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::RecordRuntimeUsageBatchService do
  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow) { create(:flow, project: project) }
  let(:other_flow) { create(:flow, project: project) }
  let(:notification) { instance_double(Namespaces::Usage::NotifyLimitsService, execute: nil) }

  before do
    create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project)
    allow(Namespaces::Usage::NotifyLimitsService).to receive(:new).and_return(notification)
  end

  def usage(flow_id, duration)
    Tucana::Shared::RuntimeUsage.new(flow_id: flow_id, duration: duration)
  end

  it { expect(described_class).to include_module(EE::Namespaces::Projects::Flows::RecordRuntimeUsageBatchService) }

  it 'notifies once per namespace touched, not once per flow' do
    described_class.new([usage(flow.id, 1_000), usage(other_flow.id, 2_000)], runtime.id).execute

    expect(Namespaces::Usage::NotifyLimitsService)
      .to have_received(:new).with(namespace: project.namespace).once
    expect(notification).to have_received(:execute).once
  end

  it 'notifies nobody when every entry was skipped' do
    described_class.new([usage(flow.id + 1_000_000, 1_000)], runtime.id).execute

    expect(Namespaces::Usage::NotifyLimitsService).not_to have_received(:new)
  end
end
