# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_type_identifier) { |n| "flow_type#{n}" }

  factory :flow_type do
    runtime
    identifier { generate(:flow_type_identifier) }
    signature { '(): undefined' }
    editable { false }
    version { '0.0.0' }
  end
end
