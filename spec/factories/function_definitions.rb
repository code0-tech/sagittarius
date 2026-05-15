# frozen_string_literal: true

FactoryBot.define do
  factory :function_definition do
    sequence(:identifier) { |n| "function_definition#{n}" }
    runtime_function_definition
    runtime_module { runtime_function_definition.runtime_module }

    after(:build) do |function_definition|
      if function_definition.runtime_function_definition.present?
        function_definition.runtime_module ||= function_definition.runtime_function_definition.runtime_module
      elsif function_definition.runtime_module.present?
        function_definition.runtime_function_definition ||= build(
          :runtime_function_definition,
          runtime: function_definition.runtime_module.runtime,
          runtime_module: function_definition.runtime_module
        )
      end
    end
  end
end
