# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_function_definition_name) { |n| "runtime_function_definition#{n}" }

  factory :runtime_function_definition do
    runtime_name { generate(:runtime_function_definition_name) }
    return_type { nil }
    runtime
    generic_keys { [] }
    parameters { [] }
  end
end
