# frozen_string_literal: true

FactoryBot.define do
  factory :namespace do
    parent factory: :organization

    trait :user do
      parent factory: :user
    end
  end
end
