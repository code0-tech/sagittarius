# frozen_string_literal: true

FactoryBot.define do
  sequence(:role_name) { |n| "role#{n}" }

  factory :team_role do
    team
    name { generate(:role_name) }
  end
end
