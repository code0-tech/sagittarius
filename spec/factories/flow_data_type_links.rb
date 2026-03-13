# frozen_string_literal: true

FactoryBot.define do
  factory :flow_data_type_link do
    flow
    referenced_data_type factory: :data_type
  end
end
