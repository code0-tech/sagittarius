# frozen_string_literal: true

module Sagittarius
  class Configuration
    extend Code0::ZeroTrack::Memoize

    def self.config
      memoize(:config) do
        file_config = YAML.safe_load_file(Rails.root.join('config/sagittarius.yml')).deep_symbolize_keys
        defaults.deep_merge(file_config)
      rescue Errno::ENOENT # config file does not exist
        defaults
      end
    end

    def self.application_setting_overrides
      config[:application_setting_overrides]
    end

    def self.defaults
      {
        rails: {
          threads: 3,
          web: {
            port: 3000,
            force_ssl: nil,
          },
          log_level: 'info',
          db: {
            host: 'localhost',
            port: 5433,
            username: 'sagittarius',
            password: 'sagittarius',
            encryption: {
              primary_key: 'YzaMv4bXYK84unYIQI4Ms4sV3ucbvWs0',
              deterministic_key: 'jgTaxTqzM15ved1S8HdXrqrjfCfF5R0h',
              key_derivation_salt: 'Z6zcLTgobXLYjXUslRsLMKxvXKq3j6DJ',
            },
          },
          secret_key_base: 'MVMD6CtQwEWrQ28TdokQakbG2FG5abOn',
        },
        application_setting_overrides: {},
      }
    end
  end
end
