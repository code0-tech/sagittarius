# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:exporter) { OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new }
  let(:span_processor) { OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(exporter) }
  let(:tracer_provider) do
    OpenTelemetry::SDK::Trace::TracerProvider.new.tap do |tp|
      tp.add_span_processor(span_processor)
    end
  end
  let(:tracer) { tracer_provider.tracer('sagittarius-cable') }

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }

  before do
    propagator = OpenTelemetry::Trace::Propagation::TraceContext::TextMapPropagator.new
    allow(OpenTelemetry).to receive(:propagation).and_return(propagator)
    allow(described_class).to receive(:tracer).and_return(tracer)
    allow(GraphqlChannel).to receive(:tracer).and_return(tracer)
  end

  describe '#subscribe_to_channel' do
    it 'creates a span with correct name' do
      stub_connection(otel_context: OpenTelemetry::Context.current)
      subscribe(token: token)

      span = exporter.finished_spans.find { |s| s.name.include?('subscribe') }
      expect(span.name).to eq('GraphqlChannel subscribe')
    end

    it 'sets messaging attributes' do
      stub_connection(otel_context: OpenTelemetry::Context.current)
      subscribe(token: token)

      span = exporter.finished_spans.find { |s| s.name.include?('subscribe') }
      expect(span.attributes['messaging.system']).to eq('action_cable')
      expect(span.attributes['messaging.operation']).to eq('subscribe')
      expect(span.attributes['code.namespace']).to eq('GraphqlChannel')
    end

    context 'when connection has a trace context' do
      let(:parent_span_context) do
        OpenTelemetry::Trace::SpanContext.new(
          trace_id: OpenTelemetry::Trace.generate_trace_id,
          span_id: OpenTelemetry::Trace.generate_span_id,
          trace_flags: OpenTelemetry::Trace::TraceFlags::SAMPLED
        )
      end
      let(:parent_context) do
        OpenTelemetry::Trace.context_with_span(
          OpenTelemetry::Trace.non_recording_span(parent_span_context)
        )
      end

      it 'creates spans as children of the connection context' do
        stub_connection(otel_context: parent_context)
        subscribe(token: token)

        span = exporter.finished_spans.find { |s| s.name.include?('subscribe') }
        expect(span.hex_trace_id).to eq(parent_span_context.hex_trace_id)
        expect(span.hex_parent_span_id).to eq(parent_span_context.hex_span_id)
      end
    end
  end

  describe '#perform_action' do
    before do
      stub_connection(otel_context: OpenTelemetry::Context.current)
      subscribe(token: token)
    end

    it 'creates a span with the action name' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span).not_to be_nil
    end

    it 'sets messaging attributes' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span).not_to be_nil
      expect(span.attributes['messaging.system']).to eq('action_cable')
      expect(span.attributes['code.namespace']).to eq('GraphqlChannel')
    end
  end
end
