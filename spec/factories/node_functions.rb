# frozen_string_literal: true

FactoryBot.define do
  factory :node_function do
    runtime_function factory: %i[runtime_function_definition]
    next_node { nil }
    node_parameters { [] }
    node_parameter_values { [] }
  end
end
