# frozen_string_literal: true

require 'rails_helper'
require 'google/protobuf/well_known_types'

RSpec.describe Sagittarius::Middleware::Grpc::Logger do
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
  let(:call) { instance_double(GRPC::ActiveCall::SingleReqView, peer: '', metadata: {}) }

  let(:interceptor) { described_class.new }

  describe '#request_response' do
    before do
      allow(Rails.logger).to receive(:info)
      allow(Rails.logger).to receive(:error)
    end

    context 'when no exception occurs' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      before { interceptor.request_response(request: request, call: call, method: method) {} }
      # rubocop:enable Lint/EmptyBlock

      it do
        expect(Rails.logger).to have_received(:info).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :OK,
            }
          )
        )
      end
    end

    context 'when a known exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.request_response(request: request, call: call, method: method) do
            raise GRPC::NotFound
          end
        end.to raise_error(GRPC::NotFound)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :NOT_FOUND,
            }
          )
        )
      end
    end

    context 'when an unknown exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.request_response(request: request, call: call, method: method) { raise :unknown }
        end.to raise_error(StandardError)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :UNKNOWN,
            }
          )
        )
      end
    end
  end

  describe '#server_streamer' do
    before do
      allow(Rails.logger).to receive(:info)
      allow(Rails.logger).to receive(:error)
    end

    context 'when no exception occurs' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      before { interceptor.server_streamer(request: request, call: call, method: method) {} }
      # rubocop:enable Lint/EmptyBlock

      it do
        expect(Rails.logger).to have_received(:info).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :OK,
            }
          )
        )
      end
    end

    context 'when a known exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.server_streamer(request: request, call: call, method: method) do
            raise GRPC::NotFound
          end
        end.to raise_error(GRPC::NotFound)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :NOT_FOUND,
            }
          )
        )
      end
    end

    context 'when an unknown exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.server_streamer(request: request, call: call, method: method) { raise :unknown }
        end.to raise_error(StandardError)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :UNKNOWN,
            }
          )
        )
      end
    end
  end

  describe '#client_streamer' do
    before do
      allow(Rails.logger).to receive(:info)
      allow(Rails.logger).to receive(:error)
    end

    context 'when no exception occurs' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      before { interceptor.client_streamer(call: call, method: method) {} }
      # rubocop:enable Lint/EmptyBlock

      it do
        expect(Rails.logger).to have_received(:info).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :OK,
            }
          )
        )
      end
    end

    context 'when a known exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.client_streamer(call: call, method: method) do
            raise GRPC::NotFound
          end
        end.to raise_error(GRPC::NotFound)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :NOT_FOUND,
            }
          )
        )
      end
    end

    context 'when an unknown exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.client_streamer(call: call, method: method) { raise :unknown }
        end.to raise_error(StandardError)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :UNKNOWN,
            }
          )
        )
      end
    end
  end

  describe '#bidi_streamer' do
    before do
      allow(Rails.logger).to receive(:info)
      allow(Rails.logger).to receive(:error)
    end

    context 'when no exception occurs' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      before { interceptor.bidi_streamer(request: [request], call: call, method: method) {} }
      # rubocop:enable Lint/EmptyBlock

      it do
        expect(Rails.logger).to have_received(:info).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :OK,
            }
          )
        )
      end
    end

    context 'when a known exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.bidi_streamer(request: [request], call: call, method: method) do
            raise GRPC::NotFound
          end
        end.to raise_error(GRPC::NotFound)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :NOT_FOUND,
            }
          )
        )
      end
    end

    context 'when an unknown exception occurs' do
      before { call_interceptor }

      def call_interceptor
        expect do
          interceptor.bidi_streamer(request: [request], call: call, method: method) { raise :unknown }
        end.to raise_error(StandardError)
      end

      it do
        expect(Rails.logger).to have_received(:error).with(
          a_hash_including(
            grpc: {
              service: 'test.Test',
              method: 'Test',
              code: :UNKNOWN,
            }
          )
        )
      end
    end
  end
end
