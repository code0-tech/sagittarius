# frozen_string_literal: true

FactoryBot.define do
  factory :namespace_project_runtime_assignment do
    runtime
    namespace_project
  end
end
