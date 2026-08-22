# frozen_string_literal: true

FactoryBot.define do
  sequence(:user_organization_pin_priority)

  factory :user_organization_pin do
    user
    organization
    priority { generate(:user_organization_pin_priority) }
  end
end
