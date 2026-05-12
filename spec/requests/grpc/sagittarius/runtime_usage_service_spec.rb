# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeUsageService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeUsageService }
  let(:runtime) { create(:runtime) }
  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:flow) { create(:flow, project: project) }

  describe 'Update' do
    let(:runtime_usage) do
      [
        Tucana::Shared::RuntimeUsage.new(
          flow_id: flow.id,
          duration: 3
        )
      ]
    end

    let(:message) do
      Tucana::Sagittarius::RuntimeUsageRequest.new(runtime_usage: runtime_usage)
    end

    it 'creates a daily runtime usage' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      usage = DailyRuntimeUsage.last
      expect(usage.flow).to eq(flow)
      expect(usage.namespace).to eq(namespace)
      expect(usage.day).to eq(Time.zone.today)
      expect(usage.usage).to eq(3)
    end

    context 'when usage already exists' do
      before do
        create(:daily_runtime_usage, flow: flow, namespace: namespace, day: Time.zone.today, usage: 5)
      end

      it 'increments the existing usage' do
        expect { stub.update(message, authorization(runtime)) }.not_to change { DailyRuntimeUsage.count }
        expect(DailyRuntimeUsage.last.usage).to eq(8)
      end
    end

    context 'when the flow does not exist' do
      let(:runtime_usage) do
        [
          Tucana::Shared::RuntimeUsage.new(
            flow_id: Flow.maximum(:id).to_i + 1,
            duration: 3
          )
        ]
      end

      it 'returns a failure response' do
        expect(stub.update(message, authorization(runtime)).success).to be(false)
        expect(DailyRuntimeUsage.count).to eq(0)
      end
    end
  end
end
