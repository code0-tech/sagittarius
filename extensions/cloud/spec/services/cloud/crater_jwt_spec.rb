# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CLOUD::CraterJwt do
  let(:secret) { 'crater-secret' }
  let(:ttl_minutes) { 5 }

  def sign(secret, exp:, iat: Time.zone.now, sub: nil)
    payload = { iat: iat.to_i, exp: exp.to_i }
    payload[:sub] = sub if sub.present?

    header = Base64.urlsafe_encode64({ alg: 'HS256', typ: 'JWT' }.to_json, padding: false)
    encoded_payload = Base64.urlsafe_encode64(payload.to_json, padding: false)
    signature = Base64.urlsafe_encode64(
      OpenSSL::HMAC.digest('SHA256', secret, "#{header}.#{encoded_payload}"),
      padding: false
    )

    "#{header}.#{encoded_payload}.#{signature}"
  end

  describe '.verify' do
    it 'returns the claims for a validly signed, unexpired token within the ttl' do
      token = sign(secret, exp: 1.minute.from_now)

      result = described_class.verify(token, secret: secret, ttl_minutes: ttl_minutes)

      expect(result).to be_a(Hash)
      expect(result['sub']).to be_nil
    end

    it 'returns the claims including the sub when one was signed' do
      token = sign(secret, exp: 1.minute.from_now, sub: '42')

      result = described_class.verify(token, secret: secret, ttl_minutes: ttl_minutes)

      expect(result['sub']).to eq('42')
    end

    it 'returns nil for a blank token' do
      expect(described_class.verify('', secret: secret, ttl_minutes: ttl_minutes)).to be_nil
      expect(described_class.verify(nil, secret: secret, ttl_minutes: ttl_minutes)).to be_nil
    end

    it 'returns nil for a blank secret' do
      token = sign(secret, exp: 1.minute.from_now)

      expect(described_class.verify(token, secret: nil, ttl_minutes: ttl_minutes)).to be_nil
    end

    it 'returns nil for a malformed token' do
      expect(described_class.verify('not-a-jwt', secret: secret, ttl_minutes: ttl_minutes)).to be_nil
    end

    it 'returns nil when the signature does not match' do
      token = sign(secret, exp: 1.minute.from_now)

      expect(described_class.verify(token, secret: 'wrong-secret', ttl_minutes: ttl_minutes)).to be_nil
    end

    it 'returns nil for an expired token' do
      token = sign(secret, exp: 1.minute.ago)

      expect(described_class.verify(token, secret: secret, ttl_minutes: ttl_minutes)).to be_nil
    end

    it 'returns nil when the token lifetime exceeds the configured ttl' do
      token = sign(secret, iat: 10.minutes.ago, exp: 1.minute.from_now)

      expect(described_class.verify(token, secret: secret, ttl_minutes: ttl_minutes)).to be_nil
    end
  end
end
