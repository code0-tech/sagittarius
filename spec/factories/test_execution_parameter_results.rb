# frozen_string_literal: true

FactoryBot.define do
  factory :test_execution_parameter_result do
    test_execution_node_result
    sequence(:position)
    value { { 'parameter' => 'ok' } }
  end
end
