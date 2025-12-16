# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_status do
    status { :stopped }
    last_heartbeat { Time.zone.today }
    status_type { :adapter }
    identifier { SecureRandom.uuid }
    feature_set { [] }
    runtime
  end
end
