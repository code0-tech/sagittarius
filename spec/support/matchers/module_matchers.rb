# frozen_string_literal: true

RSpec::Matchers.define :include_module do |expected|
  actual = nil

  match do |a|
    actual = a
    actual = actual.class unless actual.instance_of?(Class)
    actual.included_modules.include?(expected)
  end

  failure_message do
    "expected #{actual} to include the #{expected} module"
  end
end
