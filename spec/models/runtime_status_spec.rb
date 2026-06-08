# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeStatus do
  subject(:runtime_status) { create(:runtime_status) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:runtime_status) }
  end

  describe '#current_status' do
    context 'when the last heartbeat is fresh' do
      before { runtime_status.last_heartbeat = Time.zone.now }

      it 'returns the stored status' do
        expect(runtime_status.current_status).to eq('stopped')
      end
    end

    context 'when the last heartbeat is stale' do
      before { runtime_status.last_heartbeat = 11.minutes.ago }

      it 'returns not responding' do
        expect(runtime_status.current_status).to eq('not_responding')
      end
    end
  end
end
