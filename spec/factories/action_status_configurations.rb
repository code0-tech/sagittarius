# frozen_string_literal: true

FactoryBot.define do
  factory :action_status_configuration do
    action_status
    flow_type_identifiers { [] }
    endpoint { nil }
  end
end
