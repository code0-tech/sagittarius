# frozen_string_literal: true

class UpdateFlowForProjectJob < ApplicationJob
  def perform(flow_id)
    flow = Flow.find_by(id: flow_id)
    return unless flow&.validation_status_valid?

    FlowHandler.update_flow(flow)
  end
end
