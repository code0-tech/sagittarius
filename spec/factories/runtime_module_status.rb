# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_module_status do
    status { :not_responding }
    last_heartbeat { nil }
    runtime_module

    initialize_with { runtime_module.runtime_module_status }
  end
end
