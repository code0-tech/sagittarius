# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_type_setting_identifier) { |n| "flow_type_setting#{n}" }

  factory :flow_type_setting do
    flow_type
    identifier { generate(:flow_type_setting_identifier) }
    unique { false }
    data_type
    default_value { '' }
  end
end
