# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_member_role do
    namespace_role factory: :namespace_role
    namespace_member factory: :namespace_member
  end
end
