# frozen_string_literal: true

FactoryBot.define do
  factory :usage_daily_aggregate do
    date { Time.zone.today }
    execution_count { 0 }
    total_execution_time_us { 0 }
    flow
    project { flow.project }
    namespace { project.namespace }
  end
end
