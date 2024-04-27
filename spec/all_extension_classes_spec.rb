# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/DescribeClass -- this test is testing all extended classes
RSpec.describe 'all extension classes', :eager_load do
  # rubocop:disable RSpec/NoExpectationExample -- these tests fail with exceptions
  it 'overrides only defined methods' do
    Sagittarius::Override.verify_all!
  end

  it 'marks all overridden methods as override' do
    InjectExtensions.extended_constants.each_pair do |core, extensions|
      Sagittarius::Override.verify_missing_overrides!(core, extensions)
    end
  end
  # rubocop:enable RSpec/NoExpectationExample
end
# rubocop:enable RSpec/DescribeClass
