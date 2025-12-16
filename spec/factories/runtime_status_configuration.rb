# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_status_configuration do
    runtime_status
    endpoint { 'http://example.com' }
  end
end
