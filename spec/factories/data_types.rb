# frozen_string_literal: true

FactoryBot.define do
  sequence(:data_type_name) { |n| "datatype#{n}" }

  factory :data_type do
    runtime
    runtime_module { association(:runtime_module, runtime: runtime) }
    identifier { generate(:data_type_name) }
    type { 'string' }
    version { '0.0.0' }
    definition_source { 'sagittarius' }

    after(:build) do |data_type|
      data_type.runtime = data_type.runtime_module.runtime if data_type.runtime_module.present?
    end
  end
end
