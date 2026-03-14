# frozen_string_literal: true

FactoryBot.define do
  factory :flow_type_setting_data_type_link do
    flow_type_setting
    referenced_data_type factory: :data_type
  end
end
