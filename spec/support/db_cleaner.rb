# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before { DatabaseCleaner.strategy = :transaction }

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = DatabaseCleaner::ActiveRecord::Truncation.new(except: ['application_settings'])
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
