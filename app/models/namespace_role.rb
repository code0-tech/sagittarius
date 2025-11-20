# frozen_string_literal: true

class NamespaceRole < ApplicationRecord
  belongs_to :namespace, inverse_of: :roles

  has_many :abilities, class_name: 'NamespaceRoleAbility', inverse_of: :namespace_role
  has_many :member_roles, class_name: 'NamespaceMemberRole', inverse_of: :role
  has_many :members, class_name: 'NamespaceMember', through: :member_roles, inverse_of: :roles
  has_many :project_assignments, class_name: 'NamespaceRoleProjectAssignment', inverse_of: :role
  has_many :assigned_projects, class_name: 'NamespaceProject',
                               through: :project_assignments,
                               inverse_of: :assigned_roles,
                               source: :project

  scope :applicable_to_project, lambda { |project|
    left_joins(:project_assignments)
      .where(project_assignments: { project: project })
      .or(where.missing(:project_assignments))
  }

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :namespace_id }
end
