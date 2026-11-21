# frozen_string_literal: true

class NamespaceRoleProjectAssignment < ApplicationRecord
  belongs_to :namespace_role, class_name: 'NamespaceRole', foreign_key: :role_id,
                              inverse_of: :namespace_role_project_assignments
  belongs_to :namespace_project, class_name: 'NamespaceProject', foreign_key: :project_id,
                                 inverse_of: :namespace_role_project_assignments
end
