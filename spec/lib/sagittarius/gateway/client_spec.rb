# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Gateway::Client do
  let(:flow_stub) { instance_double(Tucana::Sagittarius::Gateway::FlowService::Stub) }
  let(:execution_stub) { instance_double(Tucana::Sagittarius::Gateway::ExecutionService::Stub) }
  let(:module_stub) { instance_double(Tucana::Sagittarius::Gateway::ModuleService::Stub) }
  let(:jwt_secret) { 'gateway-secret' }
  let(:jwt_ttl_seconds) { 300 }
  let(:client) do
    described_class.new(host: 'gateway.example:50060', jwt_secret: jwt_secret, jwt_ttl_seconds: jwt_ttl_seconds)
  end

  before do
    allow(Tucana::Sagittarius::Gateway::FlowService::Stub).to receive(:new).and_return(flow_stub)
    allow(Tucana::Sagittarius::Gateway::ExecutionService::Stub).to receive(:new).and_return(execution_stub)
    allow(Tucana::Sagittarius::Gateway::ModuleService::Stub).to receive(:new).and_return(module_stub)
    allow(flow_stub).to receive(:push)
    allow(execution_stub).to receive(:push)
    allow(module_stub).to receive(:push)
  end

  describe '#push_flow' do
    it 'pushes a FlowPushRequest for the runtime with a signed JWT' do
      response = Tucana::Sagittarius::Gateway::FlowResponse.new(deleted_flow_id: 1)

      client.push_flow(42, response)

      expect(Tucana::Sagittarius::Gateway::FlowService::Stub)
        .to have_received(:new).with('gateway.example:50060', :this_channel_is_insecure)
      expect(flow_stub).to have_received(:push) do |request, options|
        expect(request).to eq(
          Tucana::Sagittarius::Gateway::FlowPushRequest.new(runtime_identifier: 42, response: response)
        )
        expect(options.fetch(:metadata).fetch(:authorization)).to start_with('Bearer ')
      end
    end
  end

  describe '#push_execution' do
    it 'pushes an ExecutionPushRequest wrapping the test execution request' do
      test_execution_request = Tucana::Sagittarius::Gateway::TestExecutionRequest.new(flow_id: 1)

      client.push_execution(42, test_execution_request)

      expect(execution_stub).to have_received(:push) do |request, options|
        expect(request).to eq(
          Tucana::Sagittarius::Gateway::ExecutionPushRequest.new(request: test_execution_request)
        )
        expect(options.fetch(:metadata).fetch(:authorization)).to start_with('Bearer ')
      end
    end
  end

  describe '#push_module_configuration' do
    it 'pushes a ModuleConfigurationPushRequest for the runtime' do
      response = Tucana::Sagittarius::Gateway::ModuleConfigurationResponse.new(
        module_configurations: Tucana::Shared::ModuleConfigurations.new(module_identifier: 'taurus')
      )

      client.push_module_configuration(42, response)

      expect(module_stub).to have_received(:push) do |request, options|
        expect(request).to eq(
          Tucana::Sagittarius::Gateway::ModuleConfigurationPushRequest.new(runtime_identifier: 42, response: response)
        )
        expect(options.fetch(:metadata).fetch(:authorization)).to start_with('Bearer ')
      end
    end
  end

  describe 'reconnecting after a broken channel' do
    it 'rebuilds the stub and retries once on GRPC::Unavailable' do
      response = Tucana::Sagittarius::Gateway::FlowResponse.new(deleted_flow_id: 1)
      reconnected_stub = instance_double(Tucana::Sagittarius::Gateway::FlowService::Stub)
      allow(flow_stub).to receive(:push).and_raise(GRPC::Unavailable)
      allow(Tucana::Sagittarius::Gateway::FlowService::Stub).to receive(:new)
        .and_return(flow_stub, reconnected_stub)
      allow(reconnected_stub).to receive(:push)

      client.push_flow(42, response)

      expect(flow_stub).to have_received(:push).once
      expect(reconnected_stub).to have_received(:push).once
      expect(Tucana::Sagittarius::Gateway::FlowService::Stub).to have_received(:new).twice
    end

    it 'raises if the retry also fails' do
      response = Tucana::Sagittarius::Gateway::FlowResponse.new(deleted_flow_id: 1)
      allow(flow_stub).to receive(:push).and_raise(GRPC::Unavailable)

      expect { client.push_flow(42, response) }.to raise_error(GRPC::Unavailable)
    end
  end

  describe 'when no gateway JWT secret is configured' do
    it 'raises a clear error' do
      expect do
        described_class.new(host: 'gateway.example:50060', jwt_secret: nil).push_flow(
          42, Tucana::Sagittarius::Gateway::FlowResponse.new
        )
      end.to raise_error(ArgumentError, 'rails.gateway.jwt_secret must be configured')
    end
  end
end
