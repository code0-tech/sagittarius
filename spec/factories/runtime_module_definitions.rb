# frozen_string_literal: true

FactoryBot.define do
  factory :runtime_module_definition do
    runtime_module
    host { 'localhost' }
    port { 3000 }
    endpoint { '/runtime' }
  end
end
