# frozen_string_literal: true

FactoryBot.define do
  factory :data_type_data_type_link do
    data_type
    referenced_data_type factory: :data_type
  end
end
