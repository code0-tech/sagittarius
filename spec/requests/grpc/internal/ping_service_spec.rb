# frozen_string_literal: true

RSpec.describe 'internal.PingService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Internal::PingService }

  describe 'Ping' do
    it 'returns the same ping id' do
      message = Tucana::Internal::PingMessage.new(ping_id: 42)
      expect(stub.ping(message, authorization).ping_id).to eq(message.ping_id)
    end
  end
end
