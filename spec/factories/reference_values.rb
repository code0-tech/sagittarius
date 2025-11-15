# frozen_string_literal: true

FactoryBot.define do
  factory :reference_value do
    node_function
    data_type_identifier { association(:data_type_identifier, data_type: association(:data_type)) }
    depth { 1 }
    node { 1 }
    scope { [] }
  end
end
