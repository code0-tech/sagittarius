# frozen_string_literal: true

class CreateNamespaceProjectRuntimeAssignments < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :namespace_project_runtime_assignments do |t|
      t.references :runtime, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :namespace_project, null: false, foreign_key: { on_delete: :cascade }, index: false

      t.index %i[runtime_id namespace_project_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
