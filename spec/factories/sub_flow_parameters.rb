# frozen_string_literal: true

FactoryBot.define do
  factory :sub_flow_parameter do
    parent_sub_flow factory: :sub_flow
    identifier { 'parameter' }
    literal_value { nil }
    cast { nil }
  end
end
