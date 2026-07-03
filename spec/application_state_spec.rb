# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/DescribeClass -- this test is testing global application state
RSpec.describe 'application state', :eager_load do
  describe 'all extension classes' do
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

  describe 'good_job' do
    it { expect(GoodJob.migrated?).to be true }

    it 'log subscriber overrides all log messages' do
      ignored_overrides = %i[info fatal debug unknown error warn logger]

      GoodJob::LogSubscriber.instance_methods(false).each do |method|
        next if ignored_overrides.include?(method)

        expect(Sagittarius::Middleware::GoodJob::LogSubscriber.method_defined?(method, false))
          .to be(true), "#{Sagittarius::Middleware::GoodJob::LogSubscriber} should define #{method}"
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
