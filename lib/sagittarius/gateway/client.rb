# frozen_string_literal: true

module Sagittarius
  module Gateway
    # Calls the Rust gateway's Push RPCs (sagittarius_gateway.proto) to inject data into the
    # persistent streams it holds open with Aquila.
    class Client
      def initialize(
        host: Sagittarius::Configuration.config[:rails][:gateway][:host],
        jwt_secret: Sagittarius::Configuration.config[:rails][:gateway][:jwt_secret],
        jwt_ttl_seconds: Sagittarius::Configuration.config[:rails][:gateway][:jwt_ttl_seconds]
      )
        @host = host
        @jwt_secret = jwt_secret
        @jwt_ttl_seconds = jwt_ttl_seconds
      end

      def push_flow(runtime_id, flow_response)
        request = Tucana::Sagittarius::Gateway::FlowPushRequest.new(
          runtime_identifier: runtime_id,
          response: flow_response
        )
        flow_stub.push(request, metadata: authentication_metadata(runtime_id))
      end

      def push_execution(runtime_id, test_execution_request)
        request = Tucana::Sagittarius::Gateway::ExecutionPushRequest.new(request: test_execution_request)
        execution_stub.push(request, metadata: authentication_metadata(runtime_id))
      end

      def push_module_configuration(runtime_id, module_configuration_response)
        request = Tucana::Sagittarius::Gateway::ModuleConfigurationPushRequest.new(
          runtime_identifier: runtime_id,
          response: module_configuration_response
        )
        module_stub.push(request, metadata: authentication_metadata(runtime_id))
      end

      private

      attr_reader :host, :jwt_secret, :jwt_ttl_seconds

      def flow_stub
        @flow_stub ||= Tucana::Sagittarius::Gateway::FlowService::Stub.new(host, :this_channel_is_insecure)
      end

      def execution_stub
        @execution_stub ||= Tucana::Sagittarius::Gateway::ExecutionService::Stub.new(host, :this_channel_is_insecure)
      end

      def module_stub
        @module_stub ||= Tucana::Sagittarius::Gateway::ModuleService::Stub.new(host, :this_channel_is_insecure)
      end

      def authentication_metadata(runtime_id)
        raise ArgumentError, 'rails.gateway.jwt_secret must be configured' if jwt_secret.to_s.empty?

        token = Sagittarius::Grpc::GatewayJwt.encode(runtime_id, secret: jwt_secret, ttl_seconds: jwt_ttl_seconds)

        { authorization: token }
      end
    end
  end
end
