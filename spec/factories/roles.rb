# frozen_string_literal: true

FactoryBot.define do
  sequence(:role_name) { |n| "role#{n}" }

  factory :role do
    name { generate(:role_name) }
    team
  end
end
