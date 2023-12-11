# frozen_string_literal: true

redis_host = ENV.fetch('SAGITTARIUS_REDIS_HOST', 'localhost')
redis_port = ENV.fetch('SAGITTARIUS_REDIS_PORT', '6380')
redis_database = ENV.fetch('SAGITTARIUS_REDIS_DATABASE', '0')

redis_host = "redis://#{redis_host}:#{redis_port}/#{redis_database}"

Rails.application.config.to_prepare do
  Sidekiq.configure_server do |config|
    config.redis = { url: redis_host }
    config.server_middleware do |chain|
      chain.add Sagittarius::Middleware::Sidekiq::Context::Server
    end

    config.logger.formatter = Class.new(Sidekiq::Logger::Formatters::Base) do
      def call(severity, time, _progname, message)
        @formatter ||= Sagittarius::Logs::JsonFormatter.new

        data = @formatter.data(severity, time, message)
        data.merge!(context: ctx) unless ctx.empty?

        Sidekiq.dump_json(data) << "\n"
      end
    end.new
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_host }
    config.client_middleware do |chain|
      chain.add Sagittarius::Middleware::Sidekiq::Context::Client
    end
  end
end
