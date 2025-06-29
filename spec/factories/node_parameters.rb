# frozen_string_literal: true

FactoryBot.define do
  factory :node_parameter do
    runtime_parameter factory: %i[runtime_parameter_definition]
    node_function
    literal_value { 'value' }
    reference_value { nil }
    function_value { nil }
  end
end
