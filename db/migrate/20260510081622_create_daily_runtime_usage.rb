# frozen_string_literal: true

class CreateDailyRuntimeUsage < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :daily_runtime_usages do |t|
      t.references :flow, null: true, foreign_key: { to_table: :flows, on_delete: :nullify }
      t.references :namespace, null: false, foreign_key: { to_table: :namespaces, on_delete: :cascade }
      t.date :day, null: false
      t.decimal :usage, null: false, default: 0

      t.timestamps_with_timezone

      t.index %i[namespace_id flow_id day], unique: true
      t.index %i[namespace_id day]
      t.index %i[flow_id day]
    end
  end
end
