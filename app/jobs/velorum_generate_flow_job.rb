# frozen_string_literal: true

class VelorumGenerateFlowJob < ApplicationJob
  def perform(id, project_id, prompt, model_identifier, flow_id = nil)
    project = NamespaceProject.find_by(id: project_id)
    return if project.nil?

    flow = flow_id.present? ? Flow.find_by(id: flow_id) : nil
    return if flow_id.present? && flow.nil?

    response = Velorum::GenerateFlowService.new(
      nil,
      project: project,
      prompt: prompt,
      model_identifier: model_identifier,
      flow: flow,
      authorize: false
    ).execute
    return unless response.success?

    SubscriptionTriggers.velorum_generate_flow(id, response.payload[:flow])
  end
end
