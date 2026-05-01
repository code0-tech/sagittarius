# frozen_string_literal: true

class DropRuntimeFeatures < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    drop_table :runtime_features do |t|
      t.references :runtime_status, null: false,
                                    foreign_key: { to_table: :runtime_statuses, on_delete: :cascade }
    end
  end
end
