# frozen_string_literal: true

FactoryBot.define do
  factory :function_definition do
    return_type factory: :data_type
    runtime_function_definition
  end
end
