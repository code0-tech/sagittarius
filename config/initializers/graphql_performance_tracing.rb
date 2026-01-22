# frozen_string_literal: true

Rails.application.config.after_initialize do
  ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)

    next if event.payload[:name] == 'SCHEMA'
    next if event.payload[:name] == 'CACHE'
    next unless GraphqlController::PerformanceCollector.sql_queries # Only track if initialized

    GraphqlController::PerformanceCollector.add_query(
      sql: event.payload[:sql],
      duration_ms: event.duration.round(2),
      name: event.payload[:name],
      cached: event.payload[:cached]
    )
  end
end
