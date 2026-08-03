# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SweepStaleRuntimeStatusesJob do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  before do
    stub_application_settings(runtime_max_heartbeat_interval_minutes: 8)
  end

  it 'marks a runtime with a stale heartbeat as not_responding and cascades to its modules' do
    runtime = create(:runtime)
    runtime.runtime_status.record_status!(status: :running, heartbeat: 10.minutes.ago)
    runtime_module = create(:runtime_module, runtime: runtime)
    runtime_module.runtime_module_status.record_status!(status: :running, heartbeat: 10.minutes.ago)

    perform_enqueued_jobs { described_class.perform_later }

    expect(runtime.runtime_status.reload).to have_attributes(status: 'not_responding')
    expect(runtime_module.runtime_module_status.reload).to have_attributes(status: 'not_responding')
  end

  it 'leaves a runtime with a fresh heartbeat untouched' do
    runtime = create(:runtime)
    runtime.runtime_status.record_status!(status: :running, heartbeat: 1.minute.ago)

    perform_enqueued_jobs { described_class.perform_later }

    expect(runtime.runtime_status.reload).to have_attributes(status: 'running')
  end

  it 'marks a single stale module as not_responding while its runtime stays healthy' do
    runtime = create(:runtime)
    runtime.runtime_status.record_status!(status: :running, heartbeat: 1.minute.ago)
    runtime_module = create(:runtime_module, runtime: runtime)
    runtime_module.runtime_module_status.record_status!(status: :running, heartbeat: 10.minutes.ago)

    perform_enqueued_jobs { described_class.perform_later }

    expect(runtime.runtime_status.reload).to have_attributes(status: 'running')
    expect(runtime_module.runtime_module_status.reload).to have_attributes(status: 'not_responding')
  end

  it 'purges daily uptime rows older than 14 days' do
    runtime_status = create(:runtime_status)
    old_row = create(:runtime_status_daily_uptime, runtime_status: runtime_status, date: 20.days.ago.to_date)
    recent_row = create(:runtime_status_daily_uptime, runtime_status: runtime_status, date: 2.days.ago.to_date)

    perform_enqueued_jobs { described_class.perform_later }

    expect(RuntimeStatusDailyUptime.exists?(old_row.id)).to be(false)
    expect(RuntimeStatusDailyUptime.exists?(recent_row.id)).to be(true)
  end

  it 'rolls an ongoing outage that started on a previous day into that day and re-anchors at today' do
    runtime_status = create(:runtime_status)

    travel_to Time.zone.local(2026, 1, 1, 10, 0, 0) do
      runtime_status.record_status!(status: :not_responding)
    end

    travel_to Time.zone.local(2026, 1, 2, 3, 0, 0) do
      perform_enqueued_jobs { described_class.perform_later }
    end

    expect(runtime_status.reload.current_outage_started_at).to eq(Time.zone.local(2026, 1, 2).beginning_of_day)
    day_one = runtime_status.daily_uptimes.find_by(date: Date.new(2026, 1, 1))
    expect(day_one.outage_seconds).to eq(14.hours.to_i)
  end
end
