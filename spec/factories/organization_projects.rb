# frozen_string_literal: true

FactoryBot.define do
  sequence(:organization_project_name) { |n| "project#{n}" }

  factory :organization_project do
    organization
    name { generate(:organization_project_name) }
    description { '' }
  end
end
