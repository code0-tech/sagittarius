# frozen_string_literal: true

class NamespaceProject < ApplicationRecord
  belongs_to :namespace, inverse_of: :projects

  has_many :runtime_assignments, class_name: 'NamespaceProjectRuntimeAssignment', inverse_of: :namespace_project
  has_many :runtimes, through: :runtime_assignments, inverse_of: :projects

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

  private

  def strip_whitespace
    name&.strip!
    description&.strip!
  end
end
