# frozen_string_literal: true

class AddPrimaryRuntimeToProject < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :namespace_projects, :primary_runtime, foreign_key: { to_table: :runtimes, on_delete: :cascade },
                                                         null: true
  end
end
