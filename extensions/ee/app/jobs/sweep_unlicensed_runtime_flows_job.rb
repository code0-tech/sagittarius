# frozen_string_literal: true

# FlowHandler only clears a runtime's flows when it reconnects or when one of its flows
# changes. This sweeps already-connected runtimes so a lapsed license takes effect without
# waiting for either of those to happen.
class SweepUnlicensedRuntimeFlowsJob < ApplicationJob
  def perform
    return if License.current.present?

    RuntimeStatus.running.find_each do |runtime_status|
      FlowHandler.gateway_client.push_flow(
        runtime_status.runtime_id,
        Tucana::Sagittarius::Gateway::FlowResponse.new(flows: Tucana::Shared::Flows.new(flows: []))
      )
    end
  end
end
