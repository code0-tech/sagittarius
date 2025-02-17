# frozen_string_literal: true

class CreateNamespaceRoleProjectAssignments < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :namespace_role_project_assignments do |t|
      t.references :role, null: false, index: false, foreign_key: { to_table: :namespace_roles }
      t.references :project, null: false, foreign_key: { to_table: :namespace_projects }

      t.index %i[role_id project_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
