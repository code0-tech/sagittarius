# frozen_string_literal: true

FactoryBot.define do
  factory :execution_runtime_status do
    status { :stopped }
    last_heartbeat { Time.zone.today }
    identifier { SecureRandom.uuid }
    runtime
  end
end
