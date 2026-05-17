# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_flow_type_setting_identifier) { |n| "runtime_flow_type_setting#{n}" }

  factory :runtime_flow_type_setting do
    runtime_flow_type
    identifier { generate(:runtime_flow_type_setting_identifier) }
    unique { :none }
    default_value { '' }
  end
end
