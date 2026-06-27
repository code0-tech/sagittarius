# frozen_string_literal: true

class VelorumGenerateFlowJob < ApplicationJob
  def perform(execution_identifier, project_id, prompt, model_identifier, flow_id = nil)
    project = NamespaceProject.find_by(id: project_id)
    return trigger_error(execution_identifier, :project_not_found, 'Project does not exist') if project.nil?

    flow = flow_id.present? ? Flow.find_by(id: flow_id) : nil
    return trigger_error(execution_identifier, :flow_not_found, 'Flow does not exist') if flow_id.present? && flow.nil?

    response = Velorum::GenerateFlowService.new(
      nil,
      project: project,
      prompt: prompt,
      model_identifier: model_identifier,
      flow: flow,
      authorize: false
    ).execute

    if response.success?
      SubscriptionTriggers.ai_generate_flow(execution_identifier, response.payload[:flow])
    else
      trigger_error(execution_identifier, response.payload[:error_code], response.message)
    end
  end

  private

  def trigger_error(execution_identifier, error_code, message)
    error = { error_code: error_code, details: [{ message: message }] }
    SubscriptionTriggers.ai_generate_flow(execution_identifier, nil, errors: [error])
  end
end
