# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::Grpc::RuntimeUsageUpdateService do
  subject(:service_response) { described_class.new(current_runtime: runtime, usages: usages).execute }

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:flow) { create(:flow, project: project) }
  let(:day) { Date.new(2026, 5, 10) }
  let(:usages) { [{ flow_id: flow.id, interval: day, usage: 3 }] }

  before do
    create(:namespace_project_runtime_assignment,
           runtime: runtime,
           namespace_project: project,
           compatible: true)
  end

  it 'creates a daily runtime usage for the flow namespace' do
    expect(service_response).to be_success

    usage = DailyRuntimeUsage.last
    expect(usage.flow).to eq(flow)
    expect(usage.namespace).to eq(namespace)
    expect(usage.day).to eq(day)
    expect(usage.usage).to eq(3)
  end

  context 'when usage already exists for the interval' do
    before do
      create(:daily_runtime_usage, flow: flow, namespace: namespace, day: day, usage: 5)
    end

    it 'increments the existing usage' do
      expect { service_response }.not_to change { DailyRuntimeUsage.count }
      expect(service_response).to be_success
      expect(DailyRuntimeUsage.last.usage).to eq(8)
    end
  end

  context 'with multiple usages' do
    let(:second_flow) { create(:flow, project: project) }
    let(:usages) do
      [
        { flow_id: flow.id, interval: day, usage: 3 },
        { flow_id: second_flow.id, interval: day, usage: 4 }
      ]
    end

    it 'records each flow usage' do
      expect(service_response).to be_success
      expect(DailyRuntimeUsage.where(day: day).pluck(:flow_id, :usage)).to contain_exactly(
        [flow.id, 3.to_d],
        [second_flow.id, 4.to_d]
      )
    end
  end

  context 'when the flow is deleted later' do
    it 'keeps the usage connected to the namespace' do
      expect(service_response).to be_success

      usage = DailyRuntimeUsage.last
      flow.delete

      expect(usage.reload.flow).to be_nil
      expect(usage.namespace).to eq(namespace)
    end
  end

  context 'when the runtime is not assigned to the project' do
    before do
      NamespaceProjectRuntimeAssignment.delete_all
    end

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:runtime_not_assigned)
      expect(DailyRuntimeUsage.count).to eq(0)
    end
  end

  context 'when the usage amount is invalid' do
    let(:usages) { [{ flow_id: flow.id, interval: day, usage: -1 }] }

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:invalid_runtime_usage)
      expect(DailyRuntimeUsage.count).to eq(0)
    end
  end

  context 'when the interval is invalid' do
    let(:usages) { [{ flow_id: flow.id, interval: 'not-a-date', usage: 1 }] }

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:invalid_runtime_usage)
      expect(DailyRuntimeUsage.count).to eq(0)
    end
  end
end
