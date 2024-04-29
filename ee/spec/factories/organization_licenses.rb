# frozen_string_literal: true

FactoryBot.define do
  factory :organization_license do
    organization
    data { '' }
  end
end
