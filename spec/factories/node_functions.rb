# frozen_string_literal: true

FactoryBot.define do
  factory :node_function do
    function_definition
    next_node { nil }
    node_parameters { [] }
    flow
    value_of_node_parameter { nil }
  end
end
