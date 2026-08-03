# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius_rails.RuntimeStatusService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::Rails::RuntimeStatusService }
  let(:runtime) { create(:runtime) }
  let!(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'taurus') }

  describe 'Update' do
    let(:heartbeat_time) { Time.zone.now }
    let(:status_info) do
      Tucana::Shared::ModuleStatus.new(
        identifier: 'taurus',
        timestamp: heartbeat_time.to_i,
        status: Tucana::Shared::ModuleStatus::StatusVariant::RUNNING
      )
    end

    let(:message) { Tucana::Sagittarius::Rails::RuntimeStatusUpdateRequest.new(status: status_info) }

    it 'updates the runtime heartbeat and marks the runtime status as running' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      expect(runtime.reload.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
      expect(runtime.runtime_status).to have_attributes(status: 'running')
      expect(runtime.runtime_status.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
    end

    it 'updates the specific module status from the reported value' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      expect(runtime_module.reload.runtime_module_status).to have_attributes(status: 'running')
      expect(runtime_module.runtime_module_status.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
    end

    context 'when the module status is not_responding' do
      let(:status_info) do
        Tucana::Shared::ModuleStatus.new(
          identifier: 'taurus',
          timestamp: heartbeat_time.to_i,
          status: Tucana::Shared::ModuleStatus::StatusVariant::NOT_RESPONDING
        )
      end

      it 'still marks the runtime itself as running, since it received a heartbeat' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(runtime.runtime_status).to have_attributes(status: 'running')
        expect(runtime_module.reload.runtime_module_status).to have_attributes(status: 'not_responding')
      end
    end

    context 'when the runtime module cannot be found' do
      let(:status_info) do
        Tucana::Shared::ModuleStatus.new(
          identifier: 'unknown-module',
          timestamp: heartbeat_time.to_i,
          status: Tucana::Shared::ModuleStatus::StatusVariant::RUNNING
        )
      end

      it 'returns an error' do
        response = stub.update(message, authorization(runtime))

        expect(response.success).to be(false)
        expect(response.error.message).to eq('Runtime module not found')
      end
    end
  end
end
