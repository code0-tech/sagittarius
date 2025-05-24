# frozen_string_literal: true

class NamespaceProjectRuntimeAssignment < ApplicationRecord
  belongs_to :runtime, inverse_of: :project_assignments
  belongs_to :namespace_project, inverse_of: :runtime_assignments

  validates :runtime, uniqueness: { scope: :namespace_project_id }
end
