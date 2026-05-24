# frozen_string_literal: true

FactoryBot.define do
  factory :sub_flow do
    node_parameter
    starting_node factory: :node_function
    function_definition { nil }
    signature { '(): VOID' }
  end
end
