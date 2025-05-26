# frozen_string_literal: true

FactoryBot.define do
  factory :flow_setting do
    flow
    definition factory: %i[flow_setting_definition]
    object { { enabled: true } }
  end
end
