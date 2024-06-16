# frozen_string_literal: true

FactoryBot.define do
  sequence(:role_name) { |n| "role#{n}" }

  factory :namespace_role do
    namespace
    name { generate(:role_name) }
  end
end
