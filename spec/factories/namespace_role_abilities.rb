# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_role_ability do
    namespace_role
    ability { nil }
  end
end
