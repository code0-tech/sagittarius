# frozen_string_literal: true

class FlowHandler < Tucana::Sagittarius::FlowService::Service
  include GrpcHandler
  include GrpcStreamHandler

  grpc_stream :update

  def self.update_started(runtime_id)
    runtime = Runtime.find(runtime_id)
    runtime.connected!
    runtime.save
  end

  def self.update_died(runtime_id)
    runtime = Runtime.find(runtime_id)
    runtime.disconnected!
    runtime.save
  end

  def self.encoders = { update: ->(grpc_object) { Tucana::Sagittarius::FlowResponse.encode(grpc_object) } }

  def self.decoders = { update: ->(string) { Tucana::Sagittarius::FlowResponse.decode(string) } }
end
