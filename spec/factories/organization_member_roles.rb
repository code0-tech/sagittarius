# frozen_string_literal: true

FactoryBot.define do
  factory :organization_member_role do
    role factory: :organization_role
    member factory: :team_member
  end
end
