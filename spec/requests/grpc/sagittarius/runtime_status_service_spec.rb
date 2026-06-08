# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeStatusService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeStatusService }

  describe 'Update' do
    let(:runtime) { create(:runtime) }
    let!(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'module_status_1') }
    let(:to_update_status) do
      Tucana::Shared::ModuleStatus.new(
        status: Tucana::Shared::ModuleStatus::StatusVariant::RUNNING,
        timestamp: Time.now.to_i,
        identifier: 'module_status_1'
      )
    end

    let(:message) do
      Tucana::Sagittarius::RuntimeStatusUpdateRequest.new(status: to_update_status)
    end

    it 'updates the runtime and module statuses' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      expect(runtime.reload.runtime_status).to have_attributes(
        status: 'running'
      )

      expect(runtime_module.reload.runtime_module_status).to have_attributes(
        status: 'running'
      )
    end

    context 'when the runtime module does not exist' do
      let(:to_update_status) do
        Tucana::Shared::ModuleStatus.new(
          status: Tucana::Shared::ModuleStatus::StatusVariant::RUNNING,
          timestamp: Time.now.to_i,
          identifier: 'missing_module'
        )
      end

      it 'returns an error response' do
        expect(stub.update(message, authorization(runtime)).success).to be(false)
      end
    end
  end
end
