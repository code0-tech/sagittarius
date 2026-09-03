# frozen_string_literal: true

require 'rails_helper'
require 'google/protobuf/well_known_types'
require 'grpc/health/v1/health_services_pb'

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

  let(:gateway_jwt_secret) { Sagittarius::Configuration.config[:rails][:gateway][:jwt_secret] }
  let(:gateway_jwt_ttl_seconds) { Sagittarius::Configuration.config[:rails][:gateway][:jwt_ttl_seconds] }

  def jwt_for(runtime)
    Sagittarius::Grpc::GatewayJwt.encode(runtime.id, secret: gateway_jwt_secret, ttl_seconds: gateway_jwt_ttl_seconds)
  end

  around do |example|
    Code0::ZeroTrack::Context.with_context { example.run }
  end

  describe '#execute' do
    context 'when no authentication is passed' do
      # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
      it 'raises Unauthenticated' do
        expect do
          interceptor.execute(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
    end

    context 'when an invalid JWT is passed' do
      let(:metadata) { { 'authorization' => 'Bearer not-a-real-jwt' } }

      # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
      it 'raises Unauthenticated' do
        expect do
          interceptor.execute(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
    end

    context 'when the JWT subject does not match an existing runtime' do
      let(:metadata) do
        {
          'authorization' => Sagittarius::Grpc::GatewayJwt.encode(
            0, secret: gateway_jwt_secret, ttl_seconds: gateway_jwt_ttl_seconds
          ),
        }
      end

      # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
      it 'raises Unauthenticated' do
        expect do
          interceptor.execute(request: request, call: call, method: method) {}
        end.to raise_error(GRPC::Unauthenticated)
      end
    end

    context 'when a valid gateway JWT is passed' do
      let(:runtime) { create(:runtime) }
      let(:metadata) { { 'authorization' => jwt_for(runtime) } }

      # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
      it 'yields and pushes the runtime onto the context' do
        interceptor.execute(request: request, call: call, method: method) {}

        expect(Code0::ZeroTrack::Context.current.to_h).to include('meta.runtime' => { id: runtime.id,
                                                                                      namespace_id: nil })
      end
    end

    context 'when an anonymous service is called' do
      let(:service_class) { Grpc::Health::V1::Health::Service }
      let(:method) { service_class.new.method(:check) }

      it 'yields without requiring authentication' do
        expect { |b| interceptor.execute(request: request, call: call, method: method, &b) }.to yield_control
      end

      context 'when an unrelated authorization header is present' do
        let(:metadata) { { 'authorization' => 'Bearer not-a-real-jwt' } }

        it 'still yields' do
          expect { |b| interceptor.execute(request: request, call: call, method: method, &b) }.to yield_control
        end
      end
    end

    context 'when TokenService is called' do
      let(:service_class) do
        Class.new do
          include GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'sagittarius_rails.TokenService'

          rpc :Verify, Google::Protobuf::Value, Google::Protobuf::Value
        end
      end
      let(:method) { Class.new(service_class) { def verify(_msg, _call); end }.new.method(:verify) }

      it 'yields without requiring a gateway JWT, even with a raw Aquila token present' do
        runtime = create(:runtime)
        metadata['authorization'] = "Bearer #{runtime.token}"

        expect { |b| interceptor.execute(request: request, call: call, method: method, &b) }.to yield_control
      end
    end
  end

  describe '#request_response' do
    let(:runtime) { create(:runtime) }
    let(:metadata) { { 'authorization' => jwt_for(runtime) } }

    # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
    it 'delegates to #execute' do
      interceptor.request_response(request: request, call: call, method: method) {}

      expect(Code0::ZeroTrack::Context.current.to_h).to include('meta.runtime' => { id: runtime.id,
                                                                                    namespace_id: nil })
    end
  end

  describe '#server_streamer' do
    let(:runtime) { create(:runtime) }
    let(:metadata) { { 'authorization' => jwt_for(runtime) } }

    # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
    it 'delegates to #execute' do
      interceptor.server_streamer(request: request, call: call, method: method) {}

      expect(Code0::ZeroTrack::Context.current.to_h).to include('meta.runtime' => { id: runtime.id,
                                                                                    namespace_id: nil })
    end
  end

  describe '#client_streamer' do
    let(:runtime) { create(:runtime) }
    let(:metadata) { { 'authorization' => jwt_for(runtime) } }

    # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
    it 'delegates to #execute' do
      interceptor.client_streamer(call: call, method: method) {}

      expect(Code0::ZeroTrack::Context.current.to_h).to include('meta.runtime' => { id: runtime.id,
                                                                                    namespace_id: nil })
    end
  end

  describe '#bidi_streamer' do
    let(:runtime) { create(:runtime) }
    let(:metadata) { { 'authorization' => jwt_for(runtime) } }

    # rubocop:disable-next Lint/EmptyBlock -- the block is part of the api and needs to be given
    it 'delegates to #execute' do
      interceptor.bidi_streamer(request: request, call: call, method: method) {}

      expect(Code0::ZeroTrack::Context.current.to_h).to include('meta.runtime' => { id: runtime.id,
                                                                                    namespace_id: nil })
    end
  end
end
