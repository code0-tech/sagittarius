# frozen_string_literal: true

FactoryBot.define do
  factory :data_type_rule do
    data_type
    variant { :regex }
    config { { pattern: '.*' } }
  end
end
