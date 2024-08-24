# frozen_string_literal: true

require 'rails_helper'
require 'google/protobuf/well_known_types'

RSpec.describe Sagittarius::Middleware::Grpc::Authentication do
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

  let(:metadata) { {} }

  let(:method) { service_class.new.method(:test) }
  let(:request) { double }
  let(:call) { instance_double(GRPC::ActiveCall::SingleReqView, peer: '', metadata: metadata) }

  let(:interceptor) { described_class.new }

  around do |example|
    Sagittarius::Context.with_context { example.run }
  end

  describe '#request_response' do
    context 'when no authentication is passed' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.request_response(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when invalid authentication is passed' do
      let(:metadata) do
        { authorization: 'token' }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.request_response(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when valid authentication is passed' do
      let(:runtime) { create(:runtime) }
      let(:metadata) do
        {
          'authorization' => runtime.token,
        }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        interceptor.request_response(request: request, call: call, method: method) {}

        expect(Sagittarius::Context.current.to_h).to include('meta.runtime' => { id: runtime.id, namespace_id: nil })
      end
      # rubocop:enable Lint/EmptyBlock
    end
  end

  describe '#server_streamer' do
    context 'when no authentication is passed' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.server_streamer(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when invalid authentication is passed' do
      let(:metadata) do
        { authorization: 'token' }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.server_streamer(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when valid authentication is passed' do
      let(:runtime) { create(:runtime) }
      let(:metadata) do
        {
          'authorization' => runtime.token,
        }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        interceptor.server_streamer(request: request, call: call, method: method) {}

        expect(Sagittarius::Context.current.to_h).to include('meta.runtime' => { id: runtime.id, namespace_id: nil })
      end
      # rubocop:enable Lint/EmptyBlock
    end
  end

  describe '#client_streamer' do
    context 'when no authentication is passed' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.client_streamer(call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when invalid authentication is passed' do
      let(:metadata) do
        { authorization: 'token' }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.client_streamer(call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when valid authentication is passed' do
      let(:runtime) { create(:runtime) }
      let(:metadata) do
        {
          'authorization' => runtime.token,
        }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        interceptor.client_streamer(call: call, method: method) {}

        expect(Sagittarius::Context.current.to_h).to include('meta.runtime' => { id: runtime.id, namespace_id: nil })
      end
      # rubocop:enable Lint/EmptyBlock
    end
  end

  describe '#bidi_streamer' do
    context 'when no authentication is passed' do
      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.bidi_streamer(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when invalid authentication is passed' do
      let(:metadata) do
        { authorization: 'token' }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        expect do
          interceptor.bidi_streamer(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
      # rubocop:enable Lint/EmptyBlock
    end

    context 'when valid authentication is passed' do
      let(:runtime) { create(:runtime) }
      let(:metadata) do
        {
          'authorization' => runtime.token,
        }
      end

      # rubocop:disable Lint/EmptyBlock -- the block is part of the api and needs to be given
      it do
        interceptor.bidi_streamer(request: request, call: call, method: method) {}

        expect(Sagittarius::Context.current.to_h).to include('meta.runtime' => { id: runtime.id, namespace_id: nil })
      end
      # rubocop:enable Lint/EmptyBlock
    end
  end
end
