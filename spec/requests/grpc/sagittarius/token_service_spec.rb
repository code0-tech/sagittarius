# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius_rails.TokenService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::Rails::TokenService }

  describe 'Verify' do
    it 'verifies a known runtime token without requiring a gateway JWT' do
      runtime = create(:runtime)
      message = Tucana::Sagittarius::Rails::TokenVerifyRequest.new(token: runtime.token)

      response = stub.verify(message)

      expect(response.verified.runtime_id).to eq(runtime.id)
    end

    it 'reports an unknown token as unverified' do
      message = Tucana::Sagittarius::Rails::TokenVerifyRequest.new(token: 'unknown-token')

      response = stub.verify(message)

      expect(response.data).to eq(:unverified)
    end
  end
end
