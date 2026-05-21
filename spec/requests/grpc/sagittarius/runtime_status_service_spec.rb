# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeStatusService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeStatusService }

  describe 'Update' do
    let(:runtime) { create(:runtime) }
    let(:timestamp) { Time.current.change(usec: 0) }

    let(:to_update_status) do
      Tucana::Shared::AdapterRuntimeStatus.new(
        status: Tucana::Shared::AdapterRuntimeStatus::Status::RUNNING,
        timestamp: timestamp.to_i * 1000,
        identifier: 'adapter_status_1',
        configurations: [
          Tucana::Shared::AdapterStatusConfiguration.new(
            endpoint: 'http://localhost:3000',
            flow_type_identifiers: %w[HTTP WEBHOOK]
          )
        ]
      )
    end

    let(:message) do
      Tucana::Sagittarius::RuntimeStatusUpdateRequest.new(adapter_runtime_status: to_update_status)
    end

    it 'creates a correct status' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)
      db_status = AdapterRuntimeStatus.last
      expect(db_status.runtime).to eq(runtime)
      expect(db_status.identifier).to eq('adapter_status_1')
      expect(db_status.status).to eq('running')
      expect(db_status.last_heartbeat.to_i).to eq(timestamp.to_i)
      expect(db_status.adapter_status_configurations.count).to eq(1)
      expect(db_status.adapter_status_configurations.first.endpoint).to eq('http://localhost:3000')
      expect(db_status.adapter_status_configurations.first.flow_type_identifiers).to eq(%w[HTTP WEBHOOK])
    end

    context 'when old configuration exists before' do
      before do
        create(:adapter_status_configuration, endpoint: 'http://old-endpoint.com',
                                              adapter_runtime_status: create(:adapter_runtime_status,
                                                                             runtime: runtime,
                                                                             identifier: 'adapter_status_1'))
      end

      it 'updates the existing configuration' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)
        expect(AdapterStatusConfiguration.count).to eq(1)
        config = AdapterStatusConfiguration.last
        expect(config.endpoint).to eq('http://localhost:3000')
        expect(config.flow_type_identifiers).to eq(%w[HTTP WEBHOOK])
      end
    end

    context 'when execution runtime status' do
      let(:to_update_status) do
        Tucana::Shared::ExecutionRuntimeStatus.new(
          status: Tucana::Shared::ExecutionRuntimeStatus::Status::RUNNING,
          timestamp: timestamp.to_i * 1000,
          identifier: 'execution_status_1'
        )
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeStatusUpdateRequest.new(execution_runtime_status: to_update_status)
      end

      it 'creates a correct status' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)
        db_status = ExecutionRuntimeStatus.last
        expect(db_status.runtime).to eq(runtime)
        expect(db_status.identifier).to eq('execution_status_1')
        expect(db_status.status).to eq('running')
        expect(db_status.last_heartbeat.to_i).to eq(timestamp.to_i)
      end
    end

    context 'when action status' do
      let(:to_update_status) do
        Tucana::Shared::ActionStatus.new(
          status: Tucana::Shared::ActionStatus::Status::RUNNING,
          timestamp: timestamp.to_i * 1000,
          identifier: 'action_status_1',
          configurations: [
            Tucana::Shared::ActionStatusConfiguration.new(
              flow_type_identifiers: %w[ACTION]
            )
          ]
        )
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeStatusUpdateRequest.new(action_status: to_update_status)
      end

      it 'creates a correct status' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)
        db_status = ActionStatus.last
        expect(db_status.runtime).to eq(runtime)
        expect(db_status.identifier).to eq('action_status_1')
        expect(db_status.status).to eq('running')
        expect(db_status.last_heartbeat.to_i).to eq(timestamp.to_i)
        expect(db_status.action_status_configurations.count).to eq(1)
        expect(db_status.action_status_configurations.first.endpoint).to be_nil
        expect(db_status.action_status_configurations.first.flow_type_identifiers).to eq(%w[ACTION])
      end
    end
  end
end
