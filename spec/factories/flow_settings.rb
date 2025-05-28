# frozen_string_literal: true

FactoryBot.define do
  factory :flow_setting do
    flow
    flow_setting_id { 'default' }
    object { { enabled: true } }
  end
end
