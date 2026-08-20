# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_module_definition_flow_type_link do
    runtime_module_definition
    flow_type
  end
end
