# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_status do
    status { :stopped }
    last_heartbeat { nil }
    runtime

    initialize_with { runtime.runtime_status }
  end
end
