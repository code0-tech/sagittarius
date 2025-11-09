# frozen_string_literal: true

class UpdateRuntimeCompatibilityJob < ApplicationJob
  def perform(conditions)
    assignments = NamespaceProjectRuntimeAssignment.where(conditions)

    assignments.each do |assignment|
      res = Runtimes::CheckRuntimeCompatibilityService.new(assignment.runtime, assignment.namespace_project).execute

      assignment.compatible = res.success?
      assignment.save!
    end
  end
end
