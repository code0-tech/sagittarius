# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_type_identifier) { |n| "flow_type#{n}" }

  factory :flow_type do
    runtime
    identifier { generate(:flow_type_identifier) }
    input_type factory: :data_type
    return_type factory: :data_type
    editable { false }
    version { '0.0.0' }
  end
end
