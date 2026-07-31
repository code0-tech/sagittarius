# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TokenHandler do
  describe '#verify' do
    it 'returns a verified runtime for a valid token' do
      runtime = create(:runtime)
      request = Tucana::Sagittarius::Rails::TokenVerifyRequest.new(token: runtime.token)

      response = described_class.new.verify(request, nil)

      expect(response.data).to eq(:verified)
      expect(response.verified.runtime_id).to eq(runtime.id)
    end

    it 'returns unverified for an unknown token' do
      request = Tucana::Sagittarius::Rails::TokenVerifyRequest.new(token: 'unknown-token')

      response = described_class.new.verify(request, nil)

      expect(response.data).to eq(:unverified)
    end
  end
end
