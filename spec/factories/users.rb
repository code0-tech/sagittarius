# frozen_string_literal: true

FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email) { |n| "user#{n}@sagittarius.code0.tech" }

  factory :user do
    username { generate(:username) }
    email { generate(:email) }
    firstname { 'MyText' }
    lastname { 'MyText' }
    password_digest { 'MyText' }
  end
end
