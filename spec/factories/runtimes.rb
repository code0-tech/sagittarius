# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_name) { |n| "runtime#{n}" }

  factory :runtime do
    name { generate(:runtime_name) }
    description { '' }
    namespace { nil }
  end
end
