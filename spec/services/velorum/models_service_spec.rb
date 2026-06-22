# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::ModelsService do
  subject(:models) { described_class.new(client: client, config: config).execute }

  let(:client) { instance_double(Sagittarius::Velorum::Client) }
  let(:config) { { enabled: true } }
  let(:models_response) do
    Tucana::Velorum::ModelsResponse.new(
      models: [
        Tucana::Velorum::Model.new(identifier: 'gpt-5', name: 'GPT-5')
      ]
    )
  end

  before do
    allow(client).to receive(:models).and_return(models_response)
  end

  it 'returns models from Velorum' do
    expect(models).to eq(models_response.models)
  end

  context 'when Velorum is disabled' do
    let(:config) { { enabled: false } }

    it 'returns an empty list without calling Velorum' do
      expect(models).to eq([])
      expect(client).not_to have_received(:models)
    end
  end

  context 'when Velorum is unreachable' do
    before do
      allow(client).to receive(:models).and_raise(
        GRPC::BadStatus.new_status_exception(GRPC::Core::StatusCodes::UNAVAILABLE, 'Connection refused')
      )
    end

    it 'returns an empty list' do
      expect(models).to eq([])
    end
  end
end
