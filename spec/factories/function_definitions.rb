# frozen_string_literal: true

FactoryBot.define do
  sequence(:function_definition_name) { |n| "runtime_function_definition#{n}" }

  factory :function_definition do
    runtime_function_definition
    runtime_name { generate(:function_definition_name) }
    parameter_definitions { [] }
    signature { '(): undefined' }
    version { '0.0.0' }
    definition_source { 'sagittarius' }
    display_icon { nil }
  end
end
