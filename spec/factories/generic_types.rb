# frozen_string_literal: true

FactoryBot.define do
  factory :generic_type do
    runtime
    generic_mappers { [] }
    data_type
  end
end
