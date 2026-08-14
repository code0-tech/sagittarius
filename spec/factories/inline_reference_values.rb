# frozen_string_literal: true

FactoryBot.define do
  factory :inline_reference_value do
    node_parameter
    signature { 'x' }
    literal_value { 'value' }
  end
end
