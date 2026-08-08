# frozen_string_literal: true

FactoryBot.define do
  factory :execution_parameter_result do
    execution_node_result
    sequence(:position)
    value { { 'parameter' => 'ok' } }

    after :build do |execution_parameter_result|
      execution_parameter_result.created_at = execution_parameter_result.execution_node_result.created_at
    end
  end
end
