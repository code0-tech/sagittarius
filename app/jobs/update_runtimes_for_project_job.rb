# frozen_string_literal: true

class UpdateRuntimesForProjectJob < ApplicationJob
  def perform(project_id)
    project = NamespaceProject.find_by(id: project_id)
    return if project.nil?

    project.runtimes.each do |runtime|
      FlowHandler.update_runtime(runtime)
    end
  end
end
