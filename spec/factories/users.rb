# frozen_string_literal: true

FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email) { |n| "user#{n}@sagittarius.code0.tech" }
  sequence(:password) { |n| "#{SecureRandom.base58(10)}-#{n}" }

  factory :user do
    username { generate(:username) }
    email { generate(:email) }
    password { generate(:password) }

    trait :mfa_totp do
      totp_secret { ROTP::Base32.random }
    end

    trait :admin do
      admin { true }
    end

    trait :with_namespace do
      after :build, &:ensure_namespace
    end

    trait :with_organization_pins do
      transient do
        organization_pins_count { 2 }
      end

      after :create do |user, evaluator|
        create_list(:user_organization_pin, evaluator.organization_pins_count, user: user)
      end
    end
  end
end
