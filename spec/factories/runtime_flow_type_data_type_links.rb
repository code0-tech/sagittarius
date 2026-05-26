# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_flow_type_data_type_link do
    runtime_flow_type
    referenced_data_type factory: :data_type
  end
end
