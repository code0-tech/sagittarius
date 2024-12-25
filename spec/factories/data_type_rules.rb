# frozen_string_literal: true

FactoryBot.define do
  factory :data_type_rule do
    data_type factory: :data_type
    variant { 1 }
    config { {} }
  end
end
