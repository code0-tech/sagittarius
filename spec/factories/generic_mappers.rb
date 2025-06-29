# frozen_string_literal: true

FactoryBot.define do
  factory :generic_mapper do
    runtime
    target { nil }
    source { nil }
    generic_combination_strategies { [] }
  end
end
