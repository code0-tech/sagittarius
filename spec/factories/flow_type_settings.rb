# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_type_setting_identifier) { |n| "flow_type_setting#{n}" }

  factory :flow_type_setting do
    flow_type
    runtime_flow_type_setting { association :runtime_flow_type_setting, runtime_flow_type: flow_type.runtime_flow_type }
    identifier { generate(:flow_type_setting_identifier) }
    unique { :none }
    default_value { '' }
    optional { false }
    hidden { false }
  end
end
