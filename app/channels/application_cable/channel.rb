# frozen_string_literal: true

module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def self.tracer
      @tracer ||= ::OpenTelemetry.tracer_provider.tracer('sagittarius-cable')
    end

    def subscribe_to_channel
      with_otel_span("#{self.class.name} subscribe", 'subscribe') do
        with_context { super }
      end
    end

    def perform_action(data)
      with_otel_span("#{self.class.name} #{data['action']}", 'process') do
        with_context { super }
      end
    end

    protected

    def find_authentication(authorization)
      return Sagittarius::Authentication.new(:none, nil) if authorization.blank?

      token_type, token = authorization.split(' ', 2)

      create_authentication(token_type, token)
    end

    def create_authentication(token_type, token)
      case token_type
      when 'Session'
        Sagittarius::Authentication.new(:session, UserSession.joins(:user).find_by(token: token, active: true,
                                                                                   users: { blocked_at: nil }))
      else
        Sagittarius::Authentication.new(:invalid, nil)
      end
    end

    def otel_context
      return ::OpenTelemetry::Context.current unless connection.respond_to?(:otel_context)

      connection.otel_context || ::OpenTelemetry::Context.current
    end

    def with_otel_span(span_name, operation, parent_context: otel_context, links: [], &block)
      attributes = {
        'messaging.system' => 'action_cable',
        'messaging.operation' => operation,
        'code.namespace' => self.class.name,
      }

      ::OpenTelemetry::Context.with_current(parent_context) do
        self.class.tracer.in_span(span_name, kind: :server, attributes: attributes, links: links) do |span|
          block.call(span)
        rescue StandardError => e
          span.record_exception(e)
          span.status = ::OpenTelemetry::Trace::Status.error(e.message)
          raise
        end
      end
    end

    def with_context(&block)
      Code0::ZeroTrack::Context.with_context(
        application: 'cable',
        ip_address: request_ip,
        &block
      )
    end

    def request_ip
      return unless connection.respond_to?(:env)

      ::Rack::Request.new(connection.env).ip
    end
  end
end
