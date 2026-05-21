# frozen_string_literal: true

FactoryBot.define do
  factory :adapter_runtime_status do
    status { :stopped }
    last_heartbeat { Time.zone.today }
    identifier { SecureRandom.uuid }
    runtime
  end
end
