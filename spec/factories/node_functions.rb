# frozen_string_literal: true

FactoryBot.define do
  factory :node_function do
    function_definition
    next_node { nil }
    node_parameters { [] }
    flow
  end
end
