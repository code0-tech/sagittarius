# frozen_string_literal: true

FactoryBot.define do
  factory :reference_path do
    path { nil }
    array_index { nil }
    reference_value
  end
end
