# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before { DatabaseCleaner.strategy = :transaction }

  config.before(:each, type: :request) { DatabaseCleaner.strategy = :truncation }

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
