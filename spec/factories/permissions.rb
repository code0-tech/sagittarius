# frozen_string_literal: true

FactoryBot.define do
  sequence(:permission_name) { |n| "permission#{n}" }

  factory :permission do
    name { generate(:permission_name) }
    description { 'MyText' }
    permission_type { 1 }
  end
end
