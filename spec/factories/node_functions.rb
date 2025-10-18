# frozen_string_literal: true

FactoryBot.define do
  factory :node_function do
    runtime_function factory: :runtime_function_definition
    next_node { nil }
    node_parameters { [] }
  end
end
