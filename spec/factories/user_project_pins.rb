# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_project_pin_priority)

  factory :user_project_pin do
    user
    project factory: :namespace_project
    namespace { project.namespace }
    priority { generate(:user_project_pin_priority) }
  end
end
