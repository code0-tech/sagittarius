# frozen_string_literal: true

class NamespaceProject < ApplicationRecord
  belongs_to :namespace, inverse_of: :projects
  belongs_to :primary_runtime, class_name: 'Runtime', optional: true

  has_many :role_assignments, class_name: 'NamespaceRoleProjectAssignment',
                              inverse_of: :project
  has_many :assigned_roles, class_name: 'NamespaceRole', through: :role_assignments,
                            inverse_of: :assigned_projects,
                            source: :project

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :namespace_id }

  validates :description, length: { maximum: 500 }, exclusion: { in: [nil] }

  before_validation :strip_whitespace

  validate :validate_primary_runtime, if: :primary_runtime_changed?

  def validate_primary_runtime
    return if primary_runtime&.namespace.nil?
    return if primary_runtime.namespace == namespace

    errors.add(:primary_runtime, :invalid_namespace, message: 'must belong to the same namespace as the project')
  end

  private

  def strip_whitespace
    name&.strip!
    description&.strip!
  end
end
