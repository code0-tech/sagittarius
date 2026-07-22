# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlChannel do
  include AuthenticationHelpers

  include_context 'with graphql subscription support'

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

  before do
    propagator = OpenTelemetry::Trace::Propagation::TraceContext::TextMapPropagator.new
    allow(OpenTelemetry).to receive(:propagation).and_return(propagator)
    allow(ApplicationCable::Channel).to receive(:tracer).and_return(tracer)
    allow(described_class).to receive(:tracer).and_return(tracer)
    stub_connection(otel_context: parent_context)
  end

  describe '#execute' do
    before { subscribe(token: token) }

    it 'creates a root span' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span.hex_parent_span_id).to eq('0000000000000000')
    end

    it 'creates a span link to the connection trace context' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span.links).not_to be_empty
      expect(span.links.first.span_context.hex_trace_id).to eq(parent_span_context.hex_trace_id)
      expect(span.links.first.span_context.hex_span_id).to eq(parent_span_context.hex_span_id)
    end

    it 'sets graphql.operation.name attribute when provided' do
      perform :execute,
              query: 'subscription EchoSub($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' },
              operationName: 'EchoSub'

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span.attributes['graphql.operation.name']).to eq('EchoSub')
    end

    it 'does not set graphql.operation.name when not provided' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel execute' }
      expect(span.attributes).not_to have_key('graphql.operation.name')
    end
  end

  describe '#unsubscribed' do
    before { subscribe(token: token) }

    it 'creates a span' do
      subscription.unsubscribe_from_channel

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel unsubscribed' }
      expect(span).not_to be_nil
    end

    it 'creates a span as child of connection context' do
      subscription.unsubscribe_from_channel

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel unsubscribed' }
      expect(span.hex_trace_id).to eq(parent_span_context.hex_trace_id)
      expect(span.hex_parent_span_id).to eq(parent_span_context.hex_span_id)
    end
  end

  describe '#verify_authentication' do
    it 'creates a span' do
      subscribe(token: token)

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel verify_authentication' }
      expect(span).not_to be_nil
    end

    it 'creates a span as child of connection context' do
      subscribe(token: token)

      span = exporter.finished_spans.find { |s| s.name == 'GraphqlChannel verify_authentication' }
      expect(span.hex_trace_id).to eq(parent_span_context.hex_trace_id)
      expect(span.hex_parent_span_id).to eq(parent_span_context.hex_span_id)
    end
  end
end
