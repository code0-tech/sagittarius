# frozen_string_literal: true

class NamespaceRoleProjectAssignment < ApplicationRecord
  belongs_to :role, class_name: 'NamespaceRole', inverse_of: :project_assignments
  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :role_assignments
end
