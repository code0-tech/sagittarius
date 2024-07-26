# frozen_string_literal: true

FactoryBot.define do
  factory :backup_code do
    token { SecureRandom.random_number(10**10).to_s.rjust(10, '0') }
    user
  end
end
