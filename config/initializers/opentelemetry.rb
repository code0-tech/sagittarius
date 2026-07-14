# frozen_string_literal: true

otel_config = Sagittarius::Configuration.config[:opentelemetry]
return unless otel_config[:enabled]

require 'opentelemetry-metrics-sdk'
require 'opentelemetry/sdk'

require_relative '../../lib/sagittarius/open_telemetry/encoding_sanitizer'

begin
  OpenTelemetry.logger.formatter = Code0::ZeroTrack::Logs::JsonFormatter.new

  resource_conventions = OpenTelemetry::SemanticConventions::Resource
  otel_resource = OpenTelemetry::SDK::Resources::Resource.create(
    resource_conventions::DEPLOYMENT_ENVIRONMENT => Rails.env.to_s,
    resource_conventions::SERVICE_NAME => otel_config[:service_name],
    resource_conventions::SERVICE_VERSION => Sagittarius::Version
  )

  if defined?(OpenTelemetry::Exporter::OTLP::Exporter)
    OpenTelemetry::Exporter::OTLP::Exporter.prepend(Sagittarius::OpenTelemetry::EncodingSanitizer)
  end
  if defined?(OpenTelemetry::Exporter::OTLP::Metrics::Util)
    OpenTelemetry::Exporter::OTLP::Metrics::Util.prepend(Sagittarius::OpenTelemetry::EncodingSanitizer)
  end
  if defined?(OpenTelemetry::Exporter::OTLP::Logs::LogsExporter)
    OpenTelemetry::Exporter::OTLP::Logs::LogsExporter.prepend(Sagittarius::OpenTelemetry::EncodingSanitizer)
  end

  traces_exporter = OpenTelemetry::Exporter::OTLP::Exporter.new(
    endpoint: otel_config[:traces_endpoint]
  )

  # we configure the exporter ourselves
  ENV['OTEL_LOGS_EXPORTER'] = 'none'
  ENV['OTEL_METRICS_EXPORTER'] = 'none'

  OpenTelemetry::SDK.configure do |c|
    c.resource = otel_resource
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(traces_exporter)
    )
    c.use_all({
                'OpenTelemetry::Instrumentation::ActiveJob' => {
                  span_naming: :job_class,
                  propagation_style: :child,
                },
              })
  end

  logs_exporter = OpenTelemetry::Exporter::OTLP::Logs::LogsExporter.new(
    endpoint: otel_config[:logs_endpoint]
  )
  logs_processor = OpenTelemetry::SDK::Logs::Export::BatchLogRecordProcessor.new(logs_exporter)
  OpenTelemetry.logger_provider.add_log_record_processor(logs_processor)

  metrics_exporter = OpenTelemetry::Exporter::OTLP::Metrics::MetricsExporter.new(
    endpoint: otel_config[:metrics_endpoint]
  )
  metric_reader = OpenTelemetry::SDK::Metrics::Export::PeriodicMetricReader.new(exporter: metrics_exporter)
  OpenTelemetry.meter_provider.add_metric_reader(metric_reader)
rescue StandardError => e
  Code0::ZeroTrack::Loggable.logger.warn(message: 'Failed to configure OpenTelemetry', exception: e)
end
