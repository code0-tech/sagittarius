# frozen_string_literal: true

class DeleteFlowForProjectJob < ApplicationJob
  def perform(project_id, flow_id)
    project = NamespaceProject.find_by(id: project_id)
    return if project.nil?

    FlowHandler.delete_flow(project, flow_id)
  end
end
