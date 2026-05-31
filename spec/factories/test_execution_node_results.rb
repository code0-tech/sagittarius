# frozen_string_literal: true

FactoryBot.define do
  factory :test_execution_node_result do
    test_execution
    node_function { nil }
    node_id { node_function&.id || 1 }
    sequence(:position)
    started_at { 2.minutes.ago }
    finished_at { 1.minute.ago }
    success { { 'node' => 'ok' } }
    error { nil }
  end
end
