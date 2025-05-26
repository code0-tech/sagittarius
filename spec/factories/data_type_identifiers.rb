# frozen_string_literal: true

FactoryBot.define do
  factory :data_type_identifier do
    generic_key { nil }
    data_type { nil }
    generic_type { nil }
    runtime
  end
end
