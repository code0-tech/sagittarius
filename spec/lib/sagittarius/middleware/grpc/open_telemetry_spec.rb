# frozen_string_literal: true

require 'rails_helper'
require 'google/protobuf/well_known_types'
require 'opentelemetry/sdk'

RSpec.describe Sagittarius::Middleware::Grpc::OpenTelemetry do
  let(:exporter) { OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new }
  let(:span_processor) { OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(exporter) }
  let(:tracer_provider) do
    OpenTelemetry::SDK::Trace::TracerProvider.new.tap do |tp|
      tp.add_span_processor(span_processor)
    end
  end
  let(:tracer) { tracer_provider.tracer('sagittarius-grpc-test') }
  let(:rpc_class) do
    Class.new do
      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'test.Test'

      rpc :Test, Google::Protobuf::Value, Google::Protobuf::Value
    end
  end
  let(:service_class) do
    Class.new(rpc_class) do
      def test(_msg, _call)
        # Do nothing
      end
    end
  end
  let(:method) { service_class.new.method(:test) }
  let(:request) { double }
  let(:metadata) { {} }
  let(:call) { instance_double(GRPC::ActiveCall::SingleReqView, metadata: metadata) }
  let(:interceptor) { described_class.new }
  let(:finished_spans) { exporter.finished_spans }
  let(:span) { finished_spans.last }

  before do
    propagator = OpenTelemetry::Trace::Propagation::TraceContext::TextMapPropagator.new
    allow(OpenTelemetry).to receive(:propagation).and_return(propagator)
    allow(described_class).to receive(:tracer).and_return(tracer)
  end

  describe '#request_response' do
    context 'when no trace context is present in metadata' do
      it 'yields control' do
        expect { |b| interceptor.request_response(request: request, call: call, method: method, &b) }
          .to yield_control
      end
    end

    context 'when valid trace context is present in metadata' do
      let(:metadata) do
        { 'traceparent' => '00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01' }
      end

      it 'yields control' do
        expect { |b| interceptor.request_response(request: request, call: call, method: method, &b) }
          .to yield_control
      end
    end

    context 'when invalid trace context is present in metadata' do
      let(:metadata) do
        { 'traceparent' => 'garbage-value' }
      end

      it 'yields control without raising' do
        expect { |b| interceptor.request_response(request: request, call: call, method: method, &b) }
          .to yield_control
      end
    end
  end

  describe '#bidi_streamer' do
    context 'when no trace context is present in metadata' do
      it 'yields control' do
        expect { |b| interceptor.bidi_streamer(request: request, call: call, method: method, &b) }
          .to yield_control
      end
    end

    context 'when valid trace context is present in metadata' do
      let(:metadata) do
        { 'traceparent' => '00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01' }
      end

      it 'yields control' do
        expect { |b| interceptor.bidi_streamer(request: request, call: call, method: method, &b) }
          .to yield_control
      end
    end
  end

  describe 'span name and kind' do
    before do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      interceptor.request_response(request: request, call: call, method: method) {}
      # rubocop:enable Lint/EmptyBlock
    end

    it 'names the span after the service and method' do
      expect(span.name).to eq('test.Test/Test')
    end

    it 'sets span kind to server' do
      expect(span.kind).to eq(:server)
    end
  end

  describe 'span attributes' do
    before do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      interceptor.request_response(request: request, call: call, method: method) {}
      # rubocop:enable Lint/EmptyBlock
    end

    it 'sets rpc.system.name to grpc' do
      expect(span.attributes['rpc.system.name']).to eq('grpc')
    end

    it 'sets rpc.method to the fully-qualified method name' do
      expect(span.attributes['rpc.method']).to eq('test.Test/Test')
    end
  end

  describe 'parent context propagation' do
    context 'when valid trace context is present' do
      let(:metadata) do
        { 'traceparent' => '00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01' }
      end

      it 'sets the remote span as parent' do
        # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
        interceptor.request_response(request: request, call: call, method: method) {}
        # rubocop:enable Lint/EmptyBlock

        expect(span.hex_trace_id).to eq('0af7651916cd43dd8448eb211c80319c')
        expect(span.hex_parent_span_id).to eq('b7ad6b7169203331')
      end
    end

    context 'when no trace context is present' do
      it 'creates a new root span' do
        # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
        interceptor.request_response(request: request, call: call, method: method) {}
        # rubocop:enable Lint/EmptyBlock

        expect(span.hex_parent_span_id).to eq('0000000000000000')
      end
    end
  end

  describe 'error handling' do
    context 'when the call succeeds' do
      before do
        # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
        interceptor.request_response(request: request, call: call, method: method) {}
        # rubocop:enable Lint/EmptyBlock
      end

      it 'sets rpc.response.status_code to OK' do
        expect(span.attributes['rpc.response.status_code']).to eq('OK')
      end

      it 'does not set error.type' do
        expect(span.attributes).not_to have_key('error.type')
      end

      it 'does not set span status to error' do
        expect(span.status.code).not_to eq(OpenTelemetry::Trace::Status::ERROR)
      end
    end

    context 'when a GRPC::BadStatus error is raised' do
      it 're-raises the error' do
        expect do
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::DeadlineExceeded, 'timeout'
          end
        end.to raise_error(GRPC::DeadlineExceeded)
      end

      it 'sets rpc.response.status_code to the gRPC code name' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::DeadlineExceeded, 'timeout'
          end
        rescue GRPC::DeadlineExceeded
          # expected
        end

        expect(span.attributes['rpc.response.status_code']).to eq('DEADLINE_EXCEEDED')
      end

      it 'sets error.type for error status codes' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::Internal, 'internal error'
          end
        rescue GRPC::Internal
          # expected
        end

        expect(span.attributes['error.type']).to eq('INTERNAL')
      end

      it 'sets span status to error for error status codes' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::Unavailable, 'service unavailable'
          end
        rescue GRPC::Unavailable
          # expected
        end

        expect(span.status.code).to eq(OpenTelemetry::Trace::Status::ERROR)
      end

      it 'does not set error.type for non-error status codes like NOT_FOUND' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::NotFound, 'not found'
          end
        rescue GRPC::NotFound
          # expected
        end

        expect(span.attributes['rpc.response.status_code']).to eq('NOT_FOUND')
        expect(span.attributes).not_to have_key('error.type')
      end
    end

    context 'when a non-gRPC StandardError is raised' do
      it 're-raises the error' do
        expect do
          interceptor.request_response(request: request, call: call, method: method) do
            raise 'something went wrong'
          end
        end.to raise_error(RuntimeError)
      end

      it 'sets error.type to the exception class name' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise 'something went wrong'
          end
        rescue RuntimeError
          # expected
        end

        expect(span.attributes['error.type']).to eq('RuntimeError')
      end

      it 'sets rpc.response.status_code to UNKNOWN' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise 'something went wrong'
          end
        rescue RuntimeError
          # expected
        end

        expect(span.attributes['rpc.response.status_code']).to eq('UNKNOWN')
      end

      it 'sets span status to error' do
        begin
          interceptor.request_response(request: request, call: call, method: method) do
            raise 'something went wrong'
          end
        rescue RuntimeError
          # expected
        end

        expect(span.status.code).to eq(OpenTelemetry::Trace::Status::ERROR)
      end
    end
  end
end
