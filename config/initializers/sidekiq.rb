# frozen_string_literal: true

redis_host = ENV.fetch('SAGITTARIUS_REDIS_HOST', 'localhost')
redis_port = ENV.fetch('SAGITTARIUS_REDIS_PORT', '6380')
redis_database = ENV.fetch('SAGITTARIUS_REDIS_DATABASE', '0')

redis_host = "redis://#{redis_host}:#{redis_port}/#{redis_database}"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_host }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_host }
end
