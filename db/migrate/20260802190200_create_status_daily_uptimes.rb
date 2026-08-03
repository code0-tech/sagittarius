# frozen_string_literal: true

class CreateStatusDailyUptimes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_status_daily_uptimes do |t|
      t.references :runtime_status, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.date :date, null: false
      t.integer :outage_seconds, null: false, default: 0
      t.decimal :uptime_percentage, precision: 5, scale: 2, null: false, default: 100.0

      t.index %i[runtime_status_id date], unique: true, name: 'idx_runtime_status_daily_uptimes_on_status_id_date'

      t.timestamps_with_timezone
    end

    create_table :runtime_module_status_daily_uptimes do |t|
      t.references :runtime_module_status, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.date :date, null: false
      t.integer :outage_seconds, null: false, default: 0
      t.decimal :uptime_percentage, precision: 5, scale: 2, null: false, default: 100.0

      t.index %i[runtime_module_status_id date], unique: true,
                                                 name: 'idx_runtime_module_status_daily_uptimes_on_status_id_date'

      t.timestamps_with_timezone
    end
  end
end
