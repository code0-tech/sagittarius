# frozen_string_literal: true

require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.around do |example|
    strategy = if example.metadata[:disable_transaction]
                 DatabaseCleaner::ActiveRecord::Truncation.new(except: ['application_settings'])
               else
                 :transaction
               end
    DatabaseCleaner.strategy = strategy
    DatabaseCleaner.cleaning { example.run }
  end
end
