# frozen_string_literal: true

FactoryBot.define do
  factory :daily_runtime_usage do
    flow
    namespace { flow.project.namespace }
    day { Time.zone.today }
    usage { 1 }
  end
end
