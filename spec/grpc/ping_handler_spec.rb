# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingHandler do
  subject(:handler) { described_class.new }

  describe '.ping' do
    let(:message) { Tucana::Internal::PingMessage.new(ping_id: 1) }

    it 'returns message with same id' do
      expect(handler.ping(message, nil).ping_id).to eq(message.ping_id)
    end
  end
end
