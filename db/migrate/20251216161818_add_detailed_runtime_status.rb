# frozen_string_literal: true

class AddDetailedRuntimeStatus < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_column :runtimes, :status, :integer, null: false, default: 0
    add_column :runtimes, :last_heartbeat, :datetime_with_timezone

    create_table :runtime_statuses do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }
      t.integer :status, null: false, default: 0
      t.integer :status_type, null: false, default: 0
      t.datetime_with_timezone :last_heartbeat
      t.text :identifier, null: false

      t.timestamps_with_timezone
    end

    create_table :runtime_features do |t|
      t.references :runtime_status, null: false,
                                    foreign_key: { to_table: :runtime_statuses, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    create_table :runtime_status_configurations do |t|
      t.references :runtime_status, null: false,
                                    foreign_key: { to_table: :runtime_statuses, on_delete: :cascade }
      t.text :endpoint, null: false

      t.timestamps_with_timezone
    end
  end
end
