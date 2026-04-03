# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_name) { |n| "Flow#{n}" }

  factory :flow do
    project factory: :namespace_project
    flow_type
    validation_status { :unvalidated }
    starting_node { nil }
    flow_settings { [] }
    signature { '(): undefined' }
    name { generate(:flow_name) }
  end
end
