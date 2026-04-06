# frozen_string_literal: true

FactoryBot.define do
  sequence(:data_type_name) { |n| "datatype#{n}" }

  factory :data_type do
    runtime
    identifier { generate(:data_type_name) }
    type { 'string' }
    version { '0.0.0' }
    definition_source { 'sagittarius' }
  end
end
