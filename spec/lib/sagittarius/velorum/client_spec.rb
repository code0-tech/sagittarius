# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Velorum::Client do
  let(:stub) { instance_double(Tucana::Velorum::InfoService::Stub) }
  let(:response) { Tucana::Velorum::ModelsResponse.new }
  let(:security_token) { 'velorum-secret' }
  let(:jwt_ttl_minutes) { 15 }
  let(:time) { Time.zone.local(2026, 6, 12, 10, 0, 0) }

  before do
    allow(Time).to receive(:now).and_return(time)
    allow(Tucana::Velorum::InfoService::Stub).to receive(:new).and_return(stub)
    allow(stub).to receive(:models).and_return(response)
  end

  it 'uses the configured Velorum gRPC host to request models' do
    described_class.new(
      host: 'velorum.example:50052',
      security_token: security_token,
      jwt_ttl_minutes: jwt_ttl_minutes
    ).models

    expect(Tucana::Velorum::InfoService::Stub)
      .to have_received(:new)
      .with('velorum.example:50052', :this_channel_is_insecure)
    expect(stub).to have_received(:models).with(
      an_instance_of(Tucana::Velorum::ModelsRequest),
      metadata: a_hash_including(authorization: kind_of(String))
    )
  end

  it 'passes a signed JWT in the authentication metadata expected by Velorum' do
    described_class.new(
      host: 'velorum.example:50052',
      security_token: security_token,
      jwt_ttl_minutes: jwt_ttl_minutes
    ).models

    expect(stub).to have_received(:models) do |_, options|
      token = options.fetch(:metadata).fetch(:authorization)
      encoded_header, encoded_payload, encoded_signature = token.split('.')
      signature_body = [encoded_header, encoded_payload].join('.')
      expected_signature = Base64.urlsafe_encode64(
        OpenSSL::HMAC.digest('SHA256', security_token, signature_body),
        padding: false
      )

      expect(JSON.parse(Base64.urlsafe_decode64(encoded_header))).to include(
        'alg' => 'HS256',
        'typ' => 'JWT'
      )
      expect(JSON.parse(Base64.urlsafe_decode64(encoded_payload))).to include(
        'iat' => time.to_i - 60,
        'exp' => time.to_i + jwt_ttl_minutes.minutes.to_i
      )
      expect(encoded_signature).to eq(expected_signature)
    end
  end

  it 'raises a clear error when no Velorum security token is configured' do
    expect do
      described_class.new(host: 'velorum.example:50052', security_token: nil).models
    end.to raise_error(ArgumentError, 'VELORUM_SECURITY_TOKEN or velorum.security_token must be configured')
  end
end
