# frozen_string_literal: true

module GrpcHandler
  include Code0::ZeroTrack::Loggable

  def self.included(base)
    GrpcHandler.handlers << base
  end

  def self.register_on_server(server)
    GrpcHandler.handlers.each do |handler|
      server.handle(handler)
      GrpcHandler.logger.info(message: 'Added handler to GRPC server', handler: handler)
    end
  end

  mattr_accessor :handlers
  GrpcHandler.handlers = []
end
