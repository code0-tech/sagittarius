# frozen_string_literal: true

FactoryBot.define do
  factory :adapter_status_configuration do
    adapter_runtime_status
    flow_type_identifiers { [] }
    endpoint { 'http://example.com' }
  end
end
