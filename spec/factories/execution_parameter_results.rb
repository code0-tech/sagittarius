# frozen_string_literal: true

FactoryBot.define do
  factory :execution_parameter_result do
    execution_node_result
    sequence(:position)
    value { { 'parameter' => 'ok' } }
  end
end
