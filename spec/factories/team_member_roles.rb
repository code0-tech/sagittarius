# frozen_string_literal: true

FactoryBot.define do
  factory :team_member_role do
    role factory: :team_role
    member factory: :team_member
  end
end
