# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_role_project_assignment do
    role factory: :namespace_role
    project factory: :namespace_project
  end
end
