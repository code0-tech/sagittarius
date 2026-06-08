# frozen_string_literal: true

FactoryBot.define do
  factory :execution_node_result do
    execution_result
    node_function { association :node_function, flow: execution_result.flow }
    function_definition { nil }
    sequence(:position)
    started_at { (2.minutes.ago.to_r * 1_000_000).to_i }
    finished_at { (1.minute.ago.to_r * 1_000_000).to_i }
    success { { 'node' => 'ok' } }
    error { nil }
  end
end
