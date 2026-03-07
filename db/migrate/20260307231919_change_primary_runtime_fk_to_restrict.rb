# frozen_string_literal: true

class ChangePrimaryRuntimeFkToRestrict < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :namespace_projects,
                       :runtimes,
                       column: :primary_runtime_id,
                       on_delete: :cascade

    add_foreign_key :namespace_projects,
                    :runtimes,
                    column: :primary_runtime_id,
                    on_delete: :restrict
  end
end
