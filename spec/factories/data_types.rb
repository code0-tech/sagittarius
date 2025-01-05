# frozen_string_literal: true

FactoryBot.define do
  sequence(:data_type_name) { |n| "datatype#{n}" }

  factory :data_type do
    variant { :primitive }
    namespace
    identifier { generate(:data_type_name) }
    parent_type { nil }
  end
end
