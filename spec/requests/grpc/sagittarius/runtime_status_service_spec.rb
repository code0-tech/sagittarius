# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius_rails.RuntimeStatusService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::Rails::RuntimeStatusService }
  let(:runtime) { create(:runtime) }
  let!(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'taurus') }
  let(:heartbeat_time) { Time.zone.now }

  describe 'Update' do
    context 'with a runtime status payload' do
      let(:status_info) { Tucana::Shared::RuntimeStatus.new(timestamp: heartbeat_time.to_i) }
      let(:message) { Tucana::Sagittarius::Rails::RuntimeStatusUpdateRequest.new(runtime_status: status_info) }

      it 'updates the runtime heartbeat and marks the runtime status as running' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(runtime.reload.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
        expect(runtime.runtime_status).to have_attributes(status: 'running')
        expect(runtime.runtime_status.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
      end

      it 'does not touch any module status' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(runtime_module.reload.runtime_module_status).to have_attributes(status: 'stopped')
      end
    end

    context 'with a module status payload' do
      let(:status_info) do
        Tucana::Shared::ModuleStatus.new(
          identifier: 'taurus',
          timestamp: heartbeat_time.to_i,
          status: Tucana::Shared::ModuleStatus::StatusVariant::RUNNING
        )
      end

      let(:message) { Tucana::Sagittarius::Rails::RuntimeStatusUpdateRequest.new(module_status: status_info) }

      it 'updates the specific module status from the reported value' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(runtime_module.reload.runtime_module_status).to have_attributes(status: 'running')
        expect(runtime_module.runtime_module_status.last_heartbeat.to_i).to eq(heartbeat_time.to_i)
      end

      it 'does not touch the runtime status' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(runtime.runtime_status).to have_attributes(status: 'stopped')
      end

      context 'when the module status is not_responding' do
        let(:status_info) do
          Tucana::Shared::ModuleStatus.new(
            identifier: 'taurus',
            timestamp: heartbeat_time.to_i,
            status: Tucana::Shared::ModuleStatus::StatusVariant::NOT_RESPONDING
          )
        end

        it 'marks the module status as not_responding' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

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
end
