# frozen_string_literal: true

FactoryBot.define do
  factory :flow do
    project factory: %i[namespace_project]
    flow_type
    starting_node factory: %i[node_function]
  end
end
