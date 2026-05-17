# frozen_string_literal: true

FactoryBot.define do
  sequence(:module_configuration_definition_identifier) { |n| "module_configuration#{n}" }

  factory :module_configuration_definition do
    runtime_module
    identifier { generate(:module_configuration_definition_identifier) }
    type { 'string' }
    default_value { nil }
    optional { false }
    hidden { false }
  end
end
