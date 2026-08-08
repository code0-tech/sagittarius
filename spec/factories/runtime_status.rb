# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_status do
    status { :not_responding }
    last_heartbeat { nil }
    runtime

    initialize_with { runtime.runtime_status }
  end
end
