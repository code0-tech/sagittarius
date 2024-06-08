# frozen_string_literal: true

FactoryBot.define do
  factory :namespace do
    parent factory: :organization
  end
end
