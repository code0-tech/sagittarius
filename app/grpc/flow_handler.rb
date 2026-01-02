# frozen_string_literal: true

class FlowHandler < Tucana::Sagittarius::FlowService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler
  include GrpcStreamHandler

  grpc_stream :update

  def self.update_runtime(runtime)
    runtime.last_heartbeat = Time.zone.now
    runtime.save!

    flows = []
    runtime.project_assignments.compatible.each do |assignment|
      assignment.namespace_project.flows.each do |flow|
        flows << flow.to_grpc
      end
    end

    send_update(
      Tucana::Sagittarius::FlowResponse.new(
        flows: Tucana::Shared::Flows.new(
          flows: flows
        )
      ),
      runtime.id
    )
  end

  def self.update_started(_runtime_id)
    logger.info(message: 'Runtime connected', runtime_id: runtime.id)

    update_runtime(runtime)
  end

  def self.encoders = { update: ->(grpc_object) { Tucana::Sagittarius::FlowResponse.encode(grpc_object) } }

  def self.decoders = { update: ->(string) { Tucana::Sagittarius::FlowResponse.decode(string) } }
end
