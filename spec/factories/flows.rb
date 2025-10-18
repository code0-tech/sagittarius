# frozen_string_literal: true

FactoryBot.define do
  factory :flow do
    project factory: :namespace_project
    flow_type
    starting_node factory: :node_function
    flow_settings { [] }
    input_type { nil }
    return_type { nil }
  end
end
