# frozen_string_literal: true

FactoryBot.define do
  factory :user_custom_attribute do
    user
    key { 'test_key' }
    value { 'test_value' }
  end
end
