# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeStatus do
  include ActiveSupport::Testing::TimeHelpers

  subject(:runtime_status) { create(:runtime_status) }

  describe 'associations' do
    it { is_expected.to have_many(:daily_uptimes).class_name('RuntimeStatusDailyUptime').inverse_of(:runtime_status) }
    it { is_expected.to belong_to(:runtime).inverse_of(:runtime_status) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:runtime_id) }
  end

  describe '#record_status!' do
    it 'updates the status and heartbeat' do
      heartbeat = Time.zone.now

      runtime_status.record_status!(status: :running, heartbeat: heartbeat)

      expect(runtime_status.status).to eq('running')
      expect(runtime_status.last_heartbeat).to eq(heartbeat)
    end

    it 'opens an outage when transitioning away from running' do
      runtime_status.record_status!(status: :running)

      expect { runtime_status.record_status!(status: :not_responding) }
        .to change { runtime_status.current_outage_started_at }.from(nil)
    end

    it 'closes an outage and records downtime when transitioning back to running' do
      outage_start = Time.zone.now.change(hour: 12)
      outage_end = Time.zone.now.change(hour: 12, min: 30)

      travel_to outage_start do
        runtime_status.record_status!(status: :not_responding)
      end

      travel_to outage_end do
        runtime_status.record_status!(status: :running)
      end

      expect(runtime_status.current_outage_started_at).to be_nil
      daily = runtime_status.daily_uptimes.find_by(date: outage_start.to_date)
      expect(daily.outage_seconds).to eq(30.minutes.to_i)
      expect(daily.uptime_percentage).to be < 100
    end

    it 'splits an outage spanning multiple days across the relevant daily rows' do
      outage_start = Time.zone.yesterday.to_datetime.change(hour: 23)
      outage_end = Time.zone.now.change(hour: 1)

      travel_to outage_start do
        runtime_status.record_status!(status: :not_responding)
      end

      travel_to outage_end do
        runtime_status.record_status!(status: :running)
      end

      day_one = runtime_status.daily_uptimes.find_by(date: outage_start.to_date)
      day_two = runtime_status.daily_uptimes.find_by(date: outage_end.to_date)
      expect(day_one.outage_seconds).to eq(1.hour.to_i)
      expect(day_two.outage_seconds).to eq(1.hour.to_i)
    end
  end

  describe '#uptime_percentages' do
    it 'returns 14 entries defaulting to 100.0 with no recorded outages' do
      expect(runtime_status.uptime_percentages).to eq([100.0] * 14)
    end

    it 'ignores rows older than 14 days without requiring them to be deleted' do
      create(:runtime_status_daily_uptime, runtime_status: runtime_status, date: 15.days.ago.to_date,
                                           outage_seconds: 3600, uptime_percentage: 0.0)

      expect(runtime_status.uptime_percentages).to eq([100.0] * 14)
    end
  end
end
