# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModuleStatus do
  subject(:runtime_module_status) { create(:runtime_module_status) }

  describe 'associations' do
    it {
      is_expected.to have_many(:daily_uptimes).class_name('RuntimeModuleStatusDailyUptime')
                                              .inverse_of(:runtime_module_status)
    }

    it { is_expected.to belong_to(:runtime_module).inverse_of(:runtime_module_status) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:runtime_module_id) }
  end

  describe '#record_status!' do
    it 'updates the status and heartbeat' do
      heartbeat = Time.zone.now

      runtime_module_status.record_status!(status: :running, heartbeat: heartbeat)

      expect(runtime_module_status.status).to eq('running')
      expect(runtime_module_status.last_heartbeat).to eq(heartbeat)
    end
  end
end
