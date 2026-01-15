# frozen_string_literal: true

FactoryBot.define do
  factory :parameter_definition do
    data_type factory: :data_type_identifier

    runtime_parameter_definition do
      association :runtime_parameter_definition, data_type: data_type
    end

    function_definition do
      association :function_definition,
                  runtime_function_definition: runtime_parameter_definition.runtime_function_definition
    end
  end
end
