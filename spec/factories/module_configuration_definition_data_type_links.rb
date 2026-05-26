# frozen_string_literal: true

FactoryBot.define do
  factory :module_configuration_definition_data_type_link do
    module_configuration_definition
    referenced_data_type factory: :data_type
  end
end
