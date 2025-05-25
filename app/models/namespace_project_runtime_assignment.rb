# frozen_string_literal: true

class NamespaceProjectRuntimeAssignment < ApplicationRecord
  belongs_to :runtime, inverse_of: :project_assignments
  belongs_to :namespace_project, inverse_of: :runtime_assignments

  validates :runtime, uniqueness: { scope: :namespace_project_id }

  validate :validate_namespaces, if: :runtime_changed?
  validate :validate_namespaces, if: :namespace_project_changed?

  private

  def validate_namespaces
    return if runtime.namespace.nil?
    return if runtime.namespace == namespace_project.namespace

    errors.add(:runtime, 'must belong to the same namespace as the project')
  end
end
