# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Velorum::Client do
  let(:stub) { instance_double(Tucana::Velorum::InfoService::Stub) }
  let(:response) { Tucana::Velorum::ModelsResponse.new }

  before do
    allow(Tucana::Velorum::InfoService::Stub).to receive(:new).and_return(stub)
    allow(stub).to receive(:models).and_return(response)
  end

  it 'uses the configured Velorum gRPC host to request models' do
    described_class.new(host: 'velorum.example:50052').models

    expect(Tucana::Velorum::InfoService::Stub)
      .to have_received(:new)
      .with('velorum.example:50052', :this_channel_is_insecure)
    expect(stub).to have_received(:models).with(an_instance_of(Tucana::Velorum::ModelsRequest))
  end
end
