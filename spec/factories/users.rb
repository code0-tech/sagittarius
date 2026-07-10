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

    trait :blocked do
      blocked_at { Time.zone.now }
    end

    trait :ghost do
      user_type { :ghost }
    end

    trait :with_namespace do
      after :build, &:ensure_namespace
    end
  end
end
