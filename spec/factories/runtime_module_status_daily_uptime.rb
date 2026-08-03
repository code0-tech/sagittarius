# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_module_status_daily_uptime do
    date { Time.zone.today }
    outage_seconds { 0 }
    uptime_percentage { 100.0 }
    runtime_module_status
  end
end
