# frozen_string_literal: true

module Sagittarius
  class Configuration
    extend Code0::ZeroTrack::Memoize

    CONFIG_FILES_ENV = 'SAGITTARIUS_CONFIG_FILES'

    def self.config
      memoize(:config) do
        configured_files = ENV.fetch(CONFIG_FILES_ENV, nil)
        config_files(configured_files).reduce(defaults) do |config, config_file|
          file_config = YAML.safe_load_file(config_file, fallback: {}).deep_symbolize_keys
          config.deep_merge(file_config)
        end
      rescue Errno::ENOENT
        raise if configured_files.present?

        defaults
      end
    end

    def self.config_files(configured_files = ENV.fetch(CONFIG_FILES_ENV, nil))
      return [Rails.root.join('config/sagittarius.yml')] if configured_files.blank?

      configured_files.split(',').map(&:strip).reject(&:empty?)
    end

    def self.application_setting_overrides
      config[:application_setting_overrides]
    end

    def self.defaults
      {
        rails: {
          web: {
            threads: 3,
            port: 3000,
            force_ssl: nil,
            bind: nil,
          },
          grpc: {
            threads: 3,
            host: '0.0.0.0:50051',
          },
          log_level: 'info',
          mailer: {
            from: 'Code0 <testmail@code0.tech>',
            address: 'smtp.example.com',
            port: 587,
            domain: 'code0.tech',
            username: 'testmail@code0.tech',
            password: 'changeme',
          },
          db: {
            host: 'localhost',
            port: 5433,
            username: 'sagittarius',
            password: 'sagittarius',
            pool_size: 4,
            encryption: {
              primary_key: 'YzaMv4bXYK84unYIQI4Ms4sV3ucbvWs0',
              deterministic_key: 'jgTaxTqzM15ved1S8HdXrqrjfCfF5R0h',
              key_derivation_salt: 'Z6zcLTgobXLYjXUslRsLMKxvXKq3j6DJ',
            },
          },
          secret_key_base: 'MVMD6CtQwEWrQ28TdokQakbG2FG5abOn',
        },
        velorum: {
          enabled: false,
          host: 'localhost:50052',
          jwt_secret: nil,
          jwt_ttl_minutes: 8,
        },
        opentelemetry: {
          enabled: false,
          service_name: 'sagittarius',
          logs_endpoint: nil,
          metrics_endpoint: nil,
          traces_endpoint: nil,
        },
        application_setting_overrides: {},
      }
    end
  end
end
