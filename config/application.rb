# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sagittarius
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enable sql log tags
    config.active_record.query_log_tags_enabled = true
    config.active_record.query_log_tags = [
      :controller,
      :job,
      {
        correlation_id: -> { Sagittarius::Context.correlation_id },
        user_id: -> { Sagittarius::Context.current&.[](:user)&.[](:id) },
        user_name: -> { Sagittarius::Context.current&.[](:user)&.[](:username) },
        application: lambda {
                       if Rails.const_defined?('Console')
                         'console'
                       else
                         Sagittarius::Context.current&.[](:application) || 'unknown'
                       end
                     },
      }
    ]
    ActiveRecord::QueryLogs.prepend_comment = true

    Rails.application.default_url_options =
      if ENV['SAGITTARIUS_RAILS_HOSTNAME'].nil?
        {
          host: 'localhost',
          port: 3000,
        }
      else
        {
          host: ENV['SAGITTARIUS_RAILS_HOSTNAME'],
          port: ENV['SAGITTARIUS_RAILS_PORT'] || 443,
          protocol: ENV['SAGITTARIUS_RAILS_PROTOCOL'] || 'https',
        }
      end

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configure active job to use sidekiq
    config.active_job.queue_adapter = :sidekiq

    # Generated with 'bin/rails db:encryption:init'
    # Use some random generated keys, production will override this with the environment variables
    config.active_record.encryption.primary_key = ENV.fetch('SAGITTARIUS_DATABASE_ENCRYPTION_PRIMARY_KEY',
                                                            'YzaMv4bXYK84unYIQI4Ms4sV3ucbvWs0')
    config.active_record.encryption.deterministic_key = ENV.fetch('SAGITTARIUS_DATABASE_ENCRYPTION_DETERMINISTIC_KEY',
                                                                  'jgTaxTqzM15ved1S8HdXrqrjfCfF5R0h')
    config.active_record.encryption.key_derivation_salt =
      ENV.fetch('SAGITTARIUS_DATABASE_ENCRYPTION_KEY_DERIVATION_SALT', 'Z6zcLTgobXLYjXUslRsLMKxvXKq3j6DJ')

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Autofix after generators
    config.generators.after_generate do |files|
      parsable_files = files.filter { |file| file.end_with?('.rb') }
      system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}", exception: true)
    end
  end
end
