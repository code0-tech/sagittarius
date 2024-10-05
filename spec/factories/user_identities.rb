# frozen_string_literal: true

FactoryBot.define do
  sequence(:identifier) { |n| "identifier#{n}" }
  factory :user_identity do
    provider_id { :google }
    identifier { generate(:identifier) }
    user
  end
end
