# frozen_string_literal: true

FactoryBot.define do
  factory :policy do
    permission
    value { 1 }
  end
end
