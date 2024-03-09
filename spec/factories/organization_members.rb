# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member do
    team
    user
  end
end
