# frozen_string_literal: true

module Sagittarius
  module Grpc
    class Launcher
      include Sagittarius::Loggable

      HOST = '0.0.0.0:50051'

      def load
        @server = GRPC::RpcServer.new(interceptors: [
          Sagittarius::Middleware::Grpc::Context.new,
          Sagittarius::Middleware::Grpc::Logger.new,
          Sagittarius::Middleware::Grpc::Authentication.new
        ].reverse) # grpc handles interceptors in opposite order. Reversing so we can list them in top-to-bottom order
        logger.info('GRPC server created')

        # TODO: make this configurable
        @server.add_http2_port(HOST, :this_port_is_insecure)

        logger.info('Loading application')
        Rails.application.eager_load!
        logger.info('Loaded application')

        GrpcHandler.register_on_server(@server)
      end

      def run!
        load if @server.nil?
        logger.info('Running server')
        @server.run_till_terminated_or_interrupted(%w[QUIT INT TERM])
      end

      def start
        load
        @server_thread = Thread.new { run! }
      end

      def stop
        @server.stop
        @server_thread.join
        @server_thread.terminate
      end
    end
  end
end
