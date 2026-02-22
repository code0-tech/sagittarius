# frozen_string_literal: true

FactoryBot.define do
  factory :reference_value do
    node_function
    parameter_index { nil }
    input_index { nil }
  end
end
