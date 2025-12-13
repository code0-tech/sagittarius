# frozen_string_literal: true

FactoryBot.define do
  sequence(:flow_name) { |n| "Flow#{n}" }

  factory :flow do
    project factory: :namespace_project
    flow_type
    starting_node { nil }
    flow_settings { [] }
    input_type { nil }
    return_type { nil }
    name { generate(:flow_name) }
  end
end
