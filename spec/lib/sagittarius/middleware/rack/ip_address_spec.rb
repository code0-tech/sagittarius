# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Middleware::Rack::IpAddress do
  let(:app) { double('app') } # rubocop:disable RSpec/VerifiedDoubles
  let(:ip) { 'the ip' }
  let(:env) { {} }
  let(:fake_request) { double('request') } # rubocop:disable RSpec/VerifiedDoubles

  before do
    allow(Rack::Request).to receive(:new).with(env).and_return(fake_request)
    allow(fake_request).to receive(:ip).and_return(ip)
  end

  describe '#call' do
    it 'adds the ip from the request to the context' do
      allow(Sagittarius::Context).to receive(:with_context)

      described_class.new(app).call(env)

      expect(Sagittarius::Context).to have_received(:with_context).with(ip_address: ip)
    end

    it 'calls the app' do
      allow(app).to receive(:call).with(env).and_return([nil, {}, nil])

      described_class.new(app).call(env)

      expect(app).to have_received(:call).with(env)
    end
  end
end
