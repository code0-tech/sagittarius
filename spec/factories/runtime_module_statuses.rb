# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_module_status do
    runtime_module
    status { :unknown }
    last_heartbeat { Time.zone.today }
  end
end
