# frozen_string_literal: true

module SubscriptionTriggers
  def self.execution_result(execution_result)
    SagittariusSchema.subscriptions.trigger(
      :namespaces_projects_flows_execution_result,
      { execution_identifier: execution_result.execution_identifier },
      execution_result,
      context: { visibility_profile: :execution }
    )
  end

  def self.ai_generate_flow(execution_identifier, flow, errors: [])
    SagittariusSchema.subscriptions.trigger(
      :ai_generate_flow,
      { execution_identifier: execution_identifier },
      { flow: flow, errors: errors },
      context: { visibility_profile: :execution }
    )
  end
end
