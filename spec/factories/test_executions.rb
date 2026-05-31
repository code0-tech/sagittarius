# frozen_string_literal: true

FactoryBot.define do
  sequence(:test_execution_identifier) { |n| "execution-#{n}" }

  factory :test_execution do
    flow
    execution_identifier { generate(:test_execution_identifier) }
    body { { 'input' => 'request' } }
    input { { 'input' => 'result' } }
    started_at { 2.minutes.ago }
    finished_at { 1.minute.ago }
    success { { 'value' => true } }
    error { nil }
  end
end
