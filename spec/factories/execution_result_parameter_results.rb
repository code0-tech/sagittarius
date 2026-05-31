# frozen_string_literal: true

FactoryBot.define do
  factory :execution_result_parameter_result do
    execution_result_node_result
    sequence(:position)
    value { { 'parameter' => 'ok' } }
  end
end
