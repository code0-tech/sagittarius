# frozen_string_literal: true

class ReassignProjectFlowDefinitionsJob < ApplicationJob
  def perform(namespace_project_id)
    project = NamespaceProject.find_by(id: namespace_project_id)
    return if project.nil?

    Namespaces::Projects::ReassignFlowDefinitionsToRuntimeService.new(project, project.primary_runtime).execute
  end
end
