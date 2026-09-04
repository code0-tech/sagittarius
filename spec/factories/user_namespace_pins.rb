# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_namespace_pin_priority)

  factory :user_namespace_pin do
    user
    namespace
    priority { generate(:user_namespace_pin_priority) }
  end
end
