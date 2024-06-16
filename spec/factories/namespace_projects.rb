# frozen_string_literal: true

FactoryBot.define do
  sequence(:namespace_project_name) { |n| "project#{n}" }

  factory :namespace_project do
    namespace
    name { generate(:namespace_project_name) }
    description { '' }
  end
end
