# frozen_string_literal: true

FactoryBot.define do
  factory :reference_value do
    data_type_identifier
    primary_level { 1 }
    secondary_level { 1 }
    tertiary_level { nil }
  end
end
