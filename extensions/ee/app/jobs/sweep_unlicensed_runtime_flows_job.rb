# frozen_string_literal: true

# FlowHandler only clears flows on reconnect or flow change; this sweeps already-connected
# runtimes so a lapsed license takes effect without waiting for either.
class SweepUnlicensedRuntimeFlowsJob < ApplicationJob
  def perform
    return unless FlowHandler.no_active_license?

    RuntimeStatus.running.find_each do |runtime_status|
      FlowHandler.gateway_client.push_flow(
        runtime_status.runtime_id,
        Tucana::Sagittarius::Gateway::FlowResponse.new(flows: Tucana::Shared::Flows.new(flows: []))
      )
    end
  end
end
