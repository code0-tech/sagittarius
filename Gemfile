# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.2'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]

  gem 'graphql-docs', '~> 4.0'

  gem 'rspec-rails', '~> 6.0'

  gem 'factory_bot_rails', '~> 6.2'
  gem 'test-prof', '~> 1.0'

  gem 'shoulda-matchers', '~> 6.0'

  gem 'rspec_junit_formatter', '~> 0.6.0', require: false
  gem 'rspec-parameterized', '~> 1.0'

  gem 'database_cleaner-active_record', '~> 2.1'

  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-cobertura', '~> 2.1', require: false
end

group :development do
  gem 'rubocop-factory_bot', '~> 2.23', require: false
  gem 'rubocop-graphql', '~> 1.3', require: false
  gem 'rubocop-rails', '~> 2.19', require: false
  gem 'rubocop-rspec', '~> 3.0', require: false
  gem 'rubocop-rspec_rails', '~> 2.30', require: false
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem 'graphql', '~> 2.1'

gem 'seed-fu', '~> 2.3'

gem 'lograge', '~> 0.14.0'

gem 'declarative_policy', '~> 1.1'

gem 'docker-api', '~> 2.2'

gem 'code0-license', '~> 0.2.0'

gem 'good_job', '~> 4.0'
