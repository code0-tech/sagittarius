# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_member_role do
    role factory: :namespace_role
    member factory: :namespace_member
  end
end
