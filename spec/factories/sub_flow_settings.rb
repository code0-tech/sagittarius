# frozen_string_literal: true

FactoryBot.define do
  factory :sub_flow_setting do
    sub_flow
    identifier { 'setting' }
    default_value { nil }
    optional { false }
    hidden { false }
  end
end
