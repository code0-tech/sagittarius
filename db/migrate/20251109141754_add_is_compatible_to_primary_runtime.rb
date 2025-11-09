# frozen_string_literal: true

class AddIsCompatibleToPrimaryRuntime < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :namespace_project_runtime_assignments, :compatible, :boolean, null: false, default: false
  end
end
