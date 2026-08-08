# frozen_string_literal: true

class CreateRuntimeAndModuleStatuses < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_statuses do |t|
      t.references :runtime, null: false, index: { unique: true },
                             foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.datetime_with_timezone :current_outage_started_at

      t.timestamps_with_timezone
    end

    create_table :runtime_module_statuses do |t|
      t.references :runtime_module, null: false, index: { unique: true },
                                    foreign_key: { to_table: :runtime_modules, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.datetime_with_timezone :current_outage_started_at

      t.timestamps_with_timezone
    end
  end
end
