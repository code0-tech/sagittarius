# frozen_string_literal: true

class CreateDailyRuntimeUsage < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :daily_runtime_usages do |t|
      t.references :flow, null: true, foreign_key: { to_table: :flows, on_delete: :nullify }
      t.references :namespace, null: false, foreign_key: { to_table: :namespaces, on_delete: :cascade }
      t.date :day
      t.decimal :usage

      t.timestamps_with_timezone
    end
  end
end
