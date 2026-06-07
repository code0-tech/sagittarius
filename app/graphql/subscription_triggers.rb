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
end
