# frozen_string_literal: true

module Sagittarius
  module Grpc
    class Launcher
      include Code0::ZeroTrack::Loggable

      HOST = Sagittarius::Configuration.config[:rails][:grpc][:host]

      def create_server
        @server = GRPC::RpcServer.new(interceptors: [
          Sagittarius::Middleware::Grpc::Context.new,
          Sagittarius::Middleware::Grpc::Logger.new,
          Sagittarius::Middleware::Grpc::Authentication.new
        ].reverse) # grpc handles interceptors in opposite order. Reversing so we can list them in top-to-bottom order
        logger.info('GRPC server created')

        @server.add_http2_port(HOST, :this_port_is_insecure)

        logger.info('Loading application')
        Rails.application.eager_load!
        logger.info('Loaded application')

        GrpcHandler.register_on_server(@server)
      end

      def run_server!
        create_server if @server.nil?
        logger.info('Running server')
        @server.run_till_terminated_or_interrupted([])
      end

      def run_stream_listener!
        GrpcStreamHandler.listen!
      end

      def start
        create_server
        @stream_thread = Thread.new { run_stream_listener! }
        @server_thread = Thread.new { run_server! }
      end

      def stop
        @server.stop
        @server_thread.join
        @server_thread.terminate

        GrpcStreamHandler.stop_listen!
        @stream_thread.join
        @stream_thread.terminate
      end
    end
  end
end
