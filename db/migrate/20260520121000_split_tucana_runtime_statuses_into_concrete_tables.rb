# frozen_string_literal: true

class SplitTucanaRuntimeStatusesIntoConcreteTables < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :adapter_runtime_statuses do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.text :identifier, null: false

      t.index %i[runtime_id identifier], unique: true

      t.timestamps_with_timezone
    end

    create_table :adapter_status_configurations do |t|
      t.references :adapter_runtime_status, null: false,
                                            foreign_key: { to_table: :adapter_runtime_statuses, on_delete: :cascade }
      t.text :flow_type_identifiers, array: true, null: false, default: []
      t.text :endpoint

      t.timestamps_with_timezone
    end

    create_table :execution_runtime_statuses do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.text :identifier, null: false

      t.index %i[runtime_id identifier], unique: true

      t.timestamps_with_timezone
    end

    create_table :action_statuses do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.text :identifier, null: false

      t.index %i[runtime_id identifier], unique: true

      t.timestamps_with_timezone
    end

    create_table :action_status_configurations do |t|
      t.references :action_status, null: false, foreign_key: { to_table: :action_statuses, on_delete: :cascade }
      t.text :flow_type_identifiers, array: true, null: false, default: []
      t.text :endpoint

      t.timestamps_with_timezone
    end

    drop_table :runtime_status_configurations do |t|
      t.references :runtime_status, null: false,
                                    foreign_key: { to_table: :runtime_statuses, on_delete: :cascade }
      t.text :endpoint, null: false
      t.timestamps_with_timezone
    end

    drop_table :runtime_statuses do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.integer :status_type, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.text :identifier, null: false
      t.timestamps_with_timezone
    end
  end
end
