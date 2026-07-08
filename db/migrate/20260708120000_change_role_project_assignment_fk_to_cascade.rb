# frozen_string_literal: true

class ChangeRoleProjectAssignmentFkToCascade < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :namespace_role_project_assignments, :namespace_roles, column: :role_id

    add_foreign_key :namespace_role_project_assignments, :namespace_roles, column: :role_id, on_delete: :cascade
  end
end
