# frozen_string_literal: true

FactoryBot.define do
  sequence(:execution_result_identifier) { |n| "execution-#{n}" }

  factory :execution_result do
    flow
    execution_identifier { generate(:execution_result_identifier) }
    input { { 'input' => 'result' } }
    started_at { 2.minutes.ago }
    finished_at { 1.minute.ago }
    success { { 'value' => true } }
    error { nil }
  end
end
