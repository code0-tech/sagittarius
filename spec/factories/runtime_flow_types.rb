# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_flow_type_identifier) { |n| "runtime_flow_type#{n}" }

  factory :runtime_flow_type do
    runtime
    runtime_module { association(:runtime_module, runtime: runtime) }
    identifier { generate(:runtime_flow_type_identifier) }
    signature { '(): undefined' }
    editable { false }
    version { '0.0.0' }
    definition_source { 'sagittarius' }
    display_icon { nil }

    after(:build) do |runtime_flow_type|
      runtime_flow_type.runtime = runtime_flow_type.runtime_module.runtime if runtime_flow_type.runtime_module.present?
    end
  end
end
