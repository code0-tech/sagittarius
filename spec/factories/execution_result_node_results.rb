# frozen_string_literal: true

FactoryBot.define do
  factory :execution_result_node_result do
    execution_result
    node_function { nil }
    sequence(:position)
    started_at { 2.minutes.ago }
    finished_at { 1.minute.ago }
    success { { 'node' => 'ok' } }
    error { nil }
  end
end
