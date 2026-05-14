# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_type_identifier) { |n| "flow_type#{n}" }

  factory :flow_type do
    runtime
    runtime_module { association(:runtime_module, runtime: runtime) }
    runtime_flow_type { association(:runtime_flow_type, runtime: runtime, runtime_module: runtime_module) }
    identifier { generate(:flow_type_identifier) }
    signature { '(): undefined' }
    editable { false }
    version { '0.0.0' }
    definition_source { 'sagittarius' }
    display_icon { nil }

    after(:build) do |flow_type|
      if flow_type.runtime_flow_type.present?
        flow_type.runtime = flow_type.runtime_flow_type.runtime
        flow_type.runtime_module = flow_type.runtime_flow_type.runtime_module
      elsif flow_type.runtime_module.present?
        flow_type.runtime = flow_type.runtime_module.runtime
      end
    end
  end
end
