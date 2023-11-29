# frozen_string_literal: true

require 'spec_helper'

require 'rubocop'
require 'rubocop/rspec/support'

RSpec.configure do |config|
  config.include_context 'config'
  config.include RuboCop::RSpec::ExpectOffense
end
