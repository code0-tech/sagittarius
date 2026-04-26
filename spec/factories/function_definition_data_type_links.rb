# frozen_string_literal: true

FactoryBot.define do
  factory :function_definition_data_type_link do
    function_definition
    referenced_data_type factory: :data_type
  end
end
