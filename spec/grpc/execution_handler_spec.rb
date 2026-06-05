# frozen_string_literal: true

require 'rails_helper'
require 'timeout'

RSpec.describe ExecutionHandler do
  after do
    GrpcStreamHandler.yielders = {}
  end

  describe '.send_execution_request' do
    it 'wraps and sends a test execution request to the runtime stream' do
      request = Tucana::Sagittarius::TestExecutionRequest.new(
        flow_id: 1,
        execution_identifier: 'execution-identifier',
        body: Tucana::Shared::Value.from_ruby('input')
      )

      allow(described_class).to receive(:send_test)

      described_class.send_execution_request(123, request)

      expect(described_class).to have_received(:send_test) do |response, runtime_id|
        expect(runtime_id).to eq(123)
        expect(response).to be_a(Tucana::Sagittarius::ExecutionLogonResponse)
        expect(response.request).to eq(request)
      end
    end
  end

  describe '#test' do
    it 'keeps the outbound stream open when the inbound stream ends' do
      runtime = create(:runtime)
      request = Tucana::Sagittarius::ExecutionLogonRequest.new(logon: Tucana::Sagittarius::Logon.new)
      call = Object.new

      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_yield

      Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.test([request], call)

        sleep 0.1

        queues = GrpcStreamHandler.yielders.dig(described_class, :test, runtime.id)
        expect(queues.size).to eq(1)

        queues.each { |queue| queue << :end }
      end
    end

    it 'closes the previous runtime stream when the runtime reconnects' do
      runtime = create(:runtime)
      call = Object.new

      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_yield

      Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        first_enumerator = described_class.new.test([], call)
        described_class.new.test([], call)

        expect(Timeout.timeout(1) { first_enumerator.to_a }).to eq([])

        GrpcStreamHandler.yielders.dig(described_class, :test, runtime.id).each { |queue| queue << :end }
      end
    end
  end
end
