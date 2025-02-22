# frozen_string_literal: true

require 'rubocop_spec_helper'
require_relative '../../../../../../tooling/rubocop/cop/sagittarius/logs/rails_logger'

RSpec.describe RuboCop::Cop::Sagittarius::Logs::RailsLogger do
  described_class::LOG_METHODS.each do |method|
    it "flags the use of Rails.logger.#{method} with a constant receiver" do
      node = "Rails.logger.#{method}('some error')"
      msg = 'Do not use `Rails.logger` directly, include `Code0::ZeroTrack::Loggable` instead'

      expect_offense(<<~CODE, node: node, msg: msg)
        %{node}
        ^{node} %{msg}
      CODE
    end
  end

  it 'does not flag the use of Rails.logger with a constant that is not Rails' do
    expect_no_offenses("AppLogger.error('some error')")
  end

  it 'does not flag the use of logger with a send receiver' do
    expect_no_offenses("file_logger.info('important info')")
  end

  it 'does not flag the use of Rails.logger.level' do
    expect_no_offenses('Rails.logger.level')
  end
end
