# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeStatusServiceRuntimeFunctionDefinitionService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeStatusService }

  describe 'Update' do
    let(:runtime) { create(:runtime) }
    let(:to_update_status) do
      Tucana::Shared::AdapterRuntimeStatus.new(
        status: Tucana::Shared::RuntimeStatus::RUNNING,
        timestamp: Time.now.to_i.to_s,
        identifier: 'adapter_status_1',
        features: ['http'],
        configurations: [
          Tucana::Shared::AdapterConfiguration.new(
            endpoint: 'http://localhost:3000'
          )
        ]
      )
    end

    let(:message) do
      Tucana::Sagittarius::RuntimeStatusUpdateRequest.new(adapter_runtime_status: to_update_status)
    end

    it 'creates a correct functions' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)
      db_status = RuntimeStatus.last
      expect(db_status.runtime).to eq(runtime)
      expect(db_status.identifier).to eq('adapter_status_1')
      expect(db_status.status_type).to eq('adapter')
      expect(db_status.status).to eq('running')
      expect(db_status.features).to eq(['http'])
      expect(db_status.runtime_status_configurations.count).to eq(1)
      expect(db_status.runtime_status_configurations.first.endpoint).to eq('http://localhost:3000')
    end

    context 'when old configuration exists before' do
      before do
        create(:runtime_status_configuration, endpoint: 'http://old-endpoint.com',
                                              runtime_status: create(:runtime_status,
                                                                     runtime: runtime,
                                                                     identifier: 'adapter_status_1'))
      end

      it 'updates the existing configuration' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)
        expect(RuntimeStatusConfiguration.count).to eq(1)
        config = RuntimeStatusConfiguration.last
        expect(config.endpoint).to eq('http://localhost:3000')
      end
    end
  end
end
