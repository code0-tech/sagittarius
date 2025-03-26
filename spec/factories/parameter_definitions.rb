# frozen_string_literal: true

FactoryBot.define do
  factory :parameter_definition do
    runtime_parameter_definition
    data_type
  end
end
