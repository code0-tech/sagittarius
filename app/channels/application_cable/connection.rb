# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    attr_reader :otel_context

    def connect
      @otel_context = extract_otel_context
    end

    private

    def extract_otel_context
      ::OpenTelemetry.propagation.extract(request.headers)
    rescue StandardError
      ::OpenTelemetry::Context.current
    end
  end
end
