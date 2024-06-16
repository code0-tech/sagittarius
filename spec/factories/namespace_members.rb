# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_member do
    namespace
    user
  end
end
