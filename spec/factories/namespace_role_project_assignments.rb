# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_role_project_assignment do
    namespace_role factory: :namespace_role
    namespace_project factory: :namespace_project
  end
end
