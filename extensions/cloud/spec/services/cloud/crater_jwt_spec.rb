# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CLOUD::CraterJwt do
  let(:secret) { 'crater-secret' }
  let(:ttl_minutes) { 5 }

  def sign(secret, exp:, iat: Time.zone.now)
    header = Base64.urlsafe_encode64({ alg: 'HS256', typ: 'JWT' }.to_json, padding: false)
    payload = Base64.urlsafe_encode64({ iat: iat.to_i, exp: exp.to_i }.to_json, padding: false)
    signature = Base64.urlsafe_encode64(
      OpenSSL::HMAC.digest('SHA256', secret, "#{header}.#{payload}"),
      padding: false
    )

    "#{header}.#{payload}.#{signature}"
  end

  describe '.valid?' do
    it 'returns true for a validly signed, unexpired token within the ttl' do
      token = sign(secret, exp: 1.minute.from_now)

      expect(described_class.valid?(token, secret: secret, ttl_minutes: ttl_minutes)).to be true
    end

    it 'returns false for a blank token' do
      expect(described_class.valid?('', secret: secret, ttl_minutes: ttl_minutes)).to be false
      expect(described_class.valid?(nil, secret: secret, ttl_minutes: ttl_minutes)).to be false
    end

    it 'returns false for a blank secret' do
      token = sign(secret, exp: 1.minute.from_now)

      expect(described_class.valid?(token, secret: nil, ttl_minutes: ttl_minutes)).to be false
    end

    it 'returns false for a malformed token' do
      expect(described_class.valid?('not-a-jwt', secret: secret, ttl_minutes: ttl_minutes)).to be false
    end

    it 'returns false when the signature does not match' do
      token = sign(secret, exp: 1.minute.from_now)

      expect(described_class.valid?(token, secret: 'wrong-secret', ttl_minutes: ttl_minutes)).to be false
    end

    it 'returns false for an expired token' do
      token = sign(secret, exp: 1.minute.ago)

      expect(described_class.valid?(token, secret: secret, ttl_minutes: ttl_minutes)).to be false
    end

    it 'returns false when the token lifetime exceeds the configured ttl' do
      token = sign(secret, iat: 10.minutes.ago, exp: 1.minute.from_now)

      expect(described_class.valid?(token, secret: secret, ttl_minutes: ttl_minutes)).to be false
    end
  end
end
