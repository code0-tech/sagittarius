# frozen_string_literal: true

class FlowHandler < Tucana::Sagittarius::FlowService::Service
  include GrpcHandler
  include GrpcStreamHandler

  grpc_stream :update

  def self.encoders = { update: -> (grpc_object) { Tucana::Sagittarius::FlowResponse.encode(grpc_object) } }

  def self.decoders = { update: -> (string) { Tucana::Sagittarius::FlowResponse.decode(string) } }

end
