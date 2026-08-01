# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Grpc::GatewayJwt do
  let(:secret) { 'gateway-secret' }
  let(:ttl_seconds) { 300 }
  let(:time) { Time.zone.local(2026, 6, 12, 10, 0, 0) }

  before do
    allow(Time).to receive(:now).and_return(time)
  end

  describe '.encode' do
    it 'signs a Bearer JWT with the runtime id as subject' do
      token = described_class.encode(42, secret: secret, ttl_seconds: ttl_seconds)

      expect(token).to start_with('Bearer ')

      encoded_header, encoded_payload, encoded_signature = token.delete_prefix('Bearer ').split('.')
      expected_signature = Base64.urlsafe_encode64(
        OpenSSL::HMAC.digest('SHA256', secret, [encoded_header, encoded_payload].join('.')),
        padding: false
      )

      expect(JSON.parse(Base64.urlsafe_decode64(encoded_header))).to include('alg' => 'HS256', 'typ' => 'JWT')
      payload = JSON.parse(Base64.urlsafe_decode64(encoded_payload))
      expect(payload).to eq('sub' => '42', 'exp' => time.to_i + ttl_seconds)
      expect(encoded_signature).to eq(expected_signature)
    end
  end

  describe '.decode' do
    it 'returns the runtime id for a validly signed, unexpired token' do
      token = described_class.encode(42, secret: secret, ttl_seconds: ttl_seconds).delete_prefix('Bearer ')

      expect(described_class.decode(token, secret: secret)).to eq(42)
    end

    it 'returns nil for a blank token' do
      expect(described_class.decode('', secret: secret)).to be_nil
      expect(described_class.decode(nil, secret: secret)).to be_nil
    end

    it 'returns nil for a malformed token' do
      expect(described_class.decode('not-a-jwt', secret: secret)).to be_nil
    end

    it 'returns nil when the signature does not match' do
      token = described_class.encode(42, secret: secret, ttl_seconds: ttl_seconds).delete_prefix('Bearer ')

      expect(described_class.decode(token, secret: 'wrong-secret')).to be_nil
    end

    it 'returns nil for an expired token' do
      token = described_class.encode(42, secret: secret, ttl_seconds: -1).delete_prefix('Bearer ')

      expect(described_class.decode(token, secret: secret)).to be_nil
    end

    it 'returns nil when the subject is not an integer' do
      header = Base64.urlsafe_encode64({ alg: 'HS256', typ: 'JWT' }.to_json, padding: false)
      payload = Base64.urlsafe_encode64({ sub: 'not-an-id', exp: time.to_i + ttl_seconds }.to_json, padding: false)
      signature = Base64.urlsafe_encode64(
        OpenSSL::HMAC.digest('SHA256', secret, "#{header}.#{payload}"),
        padding: false
      )

      expect(described_class.decode("#{header}.#{payload}.#{signature}", secret: secret)).to be_nil
    end
  end
end
