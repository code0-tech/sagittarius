# frozen_string_literal: true

class NamespaceRole < ApplicationRecord
  belongs_to :namespace, inverse_of: :namespace_roles

  has_many :namespace_role_abilities, class_name: 'NamespaceRoleAbility', inverse_of: :namespace_role
  has_many :namespace_member_roles, class_name: 'NamespaceMemberRole', inverse_of: :namespace_role
  has_many :namespace_members, class_name: 'NamespaceMember', through: :namespace_member_roles,
                               source: :namespace_member, inverse_of: :namespace_roles
  has_many :namespace_role_project_assignments, class_name: 'NamespaceRoleProjectAssignment',
                                                inverse_of: :namespace_role
  has_many :namespace_projects, class_name: 'NamespaceProject',
                                through: :namespace_role_project_assignments,
                                inverse_of: :namespace_roles,
                                source: :namespace_project

  scope :applicable_to_project, lambda { |project|
    left_joins(:namespace_role_project_assignments)
      .where(namespace_role_project_assignments: { project_id: project })
      .or(where.missing(:namespace_role_project_assignments))
  }

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :namespace_id }
end
