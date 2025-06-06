# frozen_string_literal: true

FactoryBot.define do
  factory :function_definition do
    return_type { nil }
    runtime_function_definition
  end
end
