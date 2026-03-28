# frozen_string_literal: true

class FlowValidationJob < ApplicationJob
  def perform(flow_id)
    flow = Flow.find_by(id: flow_id)
    return if flow.nil?

    Namespaces::Projects::Flows::ValidationService.new(flow).execute
  end
end
