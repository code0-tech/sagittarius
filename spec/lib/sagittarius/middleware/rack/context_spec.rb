# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Middleware::Rack::Context do
  let(:app) { double('app') } # rubocop:disable RSpec/VerifiedDoubles
  let(:correlation_id) { 'the id' }
  let(:metadata) { { 'user' => { 'id' => 1 } } }
  let(:header_metadata) do
    metadata.merge({
                     Code0::ZeroTrack::Context::CORRELATION_ID_KEY => correlation_id,
                     'application' => 'puma',
                   })
  end
  let(:env) { {} }
  let(:fake_request) { double('request') } # rubocop:disable RSpec/VerifiedDoubles

  before do
    allow(ActionDispatch::Request).to receive(:new).with(env).and_return(fake_request)
    allow(fake_request).to receive(:request_id).and_return(correlation_id)
  end

  describe '#call' do
    it 'adds the correlation id from the request to the context' do
      allow(Code0::ZeroTrack::Context).to receive(:with_context)

      described_class.new(app).call(env)

      expect(Code0::ZeroTrack::Context).to have_received(:with_context).with(
        a_hash_including(Code0::ZeroTrack::Context::CORRELATION_ID_KEY => correlation_id)
      )
    end

    it 'calls the app' do
      allow(app).to receive(:call).with(env).and_return([nil, {}, nil])

      described_class.new(app).call(env)

      expect(app).to have_received(:call).with(env)
    end

    it 'injects meta headers' do
      Code0::ZeroTrack::Context.push(metadata)

      allow(app).to receive(:call).with(env).and_return([nil, {}, nil])

      _, headers, = described_class.new(app).call(env)

      expect(app).to have_received(:call).with(env)
      expect(JSON.parse(headers['X-Sagittarius-Meta'])).to eq(header_metadata)
    end
  end
end
