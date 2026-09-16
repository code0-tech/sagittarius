# frozen_string_literal: true

class EnforceRuntimeUsageLimitJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  DELAY = 10.minutes

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { self.class.concurrency_key_for(arguments.first) }
  )

  def self.enqueue_for(flow)
    set(wait: DELAY).perform_later(flow.id)
  end

  def self.concurrency_key_for(flow_id)
    flow = Flow.find_by(id: flow_id)
    scope_key = if flow
                  Namespaces::Projects::Flows::EnforceUsageLimitService.concurrency_scope_key(flow)
                else
                  "flow-#{flow_id}"
                end

    "enforce_runtime_usage_limit-#{scope_key}"
  end

  def perform(flow_id)
    flow = Flow.find_by(id: flow_id)
    return if flow.nil?

    Namespaces::Projects::Flows::EnforceUsageLimitService.new(flow).execute
  end
end
