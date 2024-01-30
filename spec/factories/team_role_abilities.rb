# frozen_string_literal: true

FactoryBot.define do
  factory :team_role_ability do
    team_role
    ability { nil }
  end
end
