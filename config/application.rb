# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require_relative '../lib/sagittarius/utils'
require_relative '../lib/sagittarius/extensions'
require_relative '../lib/sagittarius/memoize'
require_relative '../lib/sagittarius/configuration'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sagittarius
  class Application < Rails::Application
    config.load_defaults 8.0

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
        runtime_id: -> { Sagittarius::Context.current&.[](:runtime)&.[](:id) },
        application: lambda {
                       if Rails.const_defined?('Console')
                         'console'
                       elsif GoodJob::CLI.within_exe?
                         'good_job'
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

    Sagittarius::Extensions.active.each do |extension|
      config.eager_load_paths += Dir.glob("#{config.root}/#{extension}/app/*")
    end

    # Configure active job to use good_job
    config.active_job.queue_adapter = :good_job

    configuration = Sagittarius::Configuration.config
    encryption_config = configuration[:rails][:db][:encryption]

    config.active_record.encryption.primary_key = encryption_config[:primary_key]
    config.active_record.encryption.deterministic_key = encryption_config[:deterministic_key]
    config.active_record.encryption.key_derivation_salt = encryption_config[:key_derivation_salt]

    config.secret_key_base = configuration[:rails][:secret_key_base]

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
