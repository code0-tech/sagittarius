# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_project_pin_priority)

  factory :user_project_pin do
    user
    namespace_project factory: :namespace_project
    namespace { namespace_project.namespace }
    priority { generate(:user_project_pin_priority) }
  end
end
