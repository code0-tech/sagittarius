# frozen_string_literal: true

FactoryBot.define do
  factory :module_configuration do
    namespace_project_runtime_assignment
    module_configuration_definition do
      association :module_configuration_definition,
                  runtime_module: association(:runtime_module, runtime: namespace_project_runtime_assignment.runtime)
    end
    value { 'configured-value' }
  end
end
