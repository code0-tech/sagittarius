# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  let(:propagator) { OpenTelemetry::Trace::Propagation::TraceContext::TextMapPropagator.new }

  before do
    allow(OpenTelemetry).to receive(:propagation).and_return(propagator)
  end

  describe '#connect' do
    context 'when traceparent is present in upgrade request headers' do
      it 'extracts and stores the trace context' do
        connect '/cable', headers: { 'Traceparent' => '00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01' }

        span_context = OpenTelemetry::Trace.current_span(connection.otel_context).context
        expect(span_context.hex_trace_id).to eq('0af7651916cd43dd8448eb211c80319c')
        expect(span_context.hex_span_id).to eq('b7ad6b7169203331')
      end
    end

    context 'when no trace headers are present' do
      it 'stores a context without error' do
        connect '/cable'

        expect(connection.otel_context).not_to be_nil
      end
    end

    context 'when invalid traceparent is present' do
      it 'stores a context without error' do
        connect '/cable', headers: { 'Traceparent' => 'garbage-value' }

        expect(connection.otel_context).not_to be_nil
      end
    end
  end
end
