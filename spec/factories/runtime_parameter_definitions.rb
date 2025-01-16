# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_parameter_definition_name) { |n| "runtime_parameter_definition#{n}" }

  factory :runtime_parameter_definition do
    runtime_function_definition
    data_type
    name { generate(:runtime_parameter_definition_name) }
  end
end
