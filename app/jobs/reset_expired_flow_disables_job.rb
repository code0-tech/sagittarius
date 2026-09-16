# frozen_string_literal: true

# Generic sweep for any Flow#disabled_until that has passed, regardless of what disabled it.
class ResetExpiredFlowDisablesJob < ApplicationJob
  def perform
    Flow.disabled_expired.find_each do |flow|
      flow.reenable!
      FlowHandler.update_flow(flow)
    end
  end
end
