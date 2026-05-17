# frozen_string_literal: true

FactoryBot.define do
  sequence(:runtime_module_identifier) { |n| "runtime_module#{n}" }

  factory :runtime_module do
    runtime
    identifier { generate(:runtime_module_identifier) }
    documentation { '' }
    author { '' }
    icon { nil }
    version { '0.0.0' }
  end
end
