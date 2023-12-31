# frozen_string_literal: true

FactoryBot.define do
  factory :team_member do
    team
    user
  end
end
