# frozen_string_literal: true

class GraphqlChannel < ApplicationCable::Channel
  periodically :verify_authentication, every: 30.seconds

  def subscribed
    @token = params[:token]
    @subscription_ids = []

    verify_authentication
  end

  def execute(data)
    connection_span_context = ::OpenTelemetry::Trace.current_span(otel_context).context
    links = if connection_span_context.valid?
              [::OpenTelemetry::Trace::Link.new(connection_span_context)]
            else
              []
            end

    with_otel_span("#{self.class.name} execute", 'process',
                   parent_context: ::OpenTelemetry::Context::ROOT, links: links) do |span|
      span.set_attribute('graphql.operation.name', data['operationName']) if data['operationName']

      result = SagittariusSchema.execute(
        query: data['query'],
        context: {
          current_authentication: find_authentication(@token),
          visibility_profile: :execution,
          channel: self,
        },
        variables: data['variables'],
        operation_name: data['operationName']
      )

      @subscription_ids << result.context[:subscription_id] if result.context[:subscription_id]

      transmit({ result: result.to_h, more: result.subscription? })
    end
  end

  def unsubscribed
    with_otel_span("#{self.class.name} unsubscribed", 'process') do
      @subscription_ids.each do |sid|
        SagittariusSchema.subscriptions.delete_subscription(sid)
      end
    end
  end

  private

  def verify_authentication
    with_otel_span("#{self.class.name} verify_authentication", 'process') do
      with_context do
        authentication = find_authentication(@token)
        return unless authentication.invalid? || authentication.none?

        @subscription_ids.each { |sid| SagittariusSchema.subscriptions.delete_subscription(sid) }
        reject
      end
    end
  end
end
