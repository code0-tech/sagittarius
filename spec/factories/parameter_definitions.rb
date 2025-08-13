# frozen_string_literal: true

FactoryBot.define do
  factory :parameter_definition do
    runtime_parameter_definition
    data_type

    function_definition do
      association :function_definition,
                  runtime_function_definition: runtime_parameter_definition.runtime_function_definition
    end
  end
end
