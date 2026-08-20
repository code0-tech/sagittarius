# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_project_usage_daily_aggregate do
    date { Time.zone.today }
    execution_count { 0 }
    total_execution_time_us { 0 }
    project factory: :namespace_project
  end
end
