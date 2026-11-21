# frozen_string_literal: true

FactoryBot.define do
  factory :ai_usage_daily_aggregate do
    date { Time.zone.today }
    flow_id { AiUsageDailyAggregate::NO_FLOW }
    generation_count { 0 }
    total_usage { 0 }
    namespace_project { association(:namespace_project) }
    namespace { namespace_project.namespace }
  end
end
