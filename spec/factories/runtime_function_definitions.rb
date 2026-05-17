# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_function_definition_name) { |n| "runtime_function_definition#{n}" }

  factory :runtime_function_definition do
    runtime_name { generate(:runtime_function_definition_name) }
    runtime
    runtime_module { association(:runtime_module, runtime: runtime) }
    parameters { [] }
    signature { '(): undefined' }
    version { '0.0.0' }
    definition_source { 'sagittarius' }
    display_icon { nil }

    after(:build) do |runtime_function_definition|
      if runtime_function_definition.runtime_module.present?
        runtime_function_definition.runtime = runtime_function_definition.runtime_module.runtime
      end
    end
  end
end
