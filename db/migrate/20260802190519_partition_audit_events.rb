# frozen_string_literal: true

class PartitionAuditEvents < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_partition_by_date_table :p_audit_events, partition_column: :created_at do |t|
      t.references :author, null: false, foreign_key: { to_table: :users, on_delete: :restrict }
      t.bigint :entity_id, null: false
      t.text :entity_type, null: false
      t.integer :action_type, null: false
      t.jsonb :details, null: false
      t.inet :ip_address
      t.bigint :target_id, null: false
      t.text :target_type, null: false

      t.timestamps_with_timezone
    end

    drop_table :audit_events do |t|
      t.references :author, null: false, foreign_key: { to_table: :users, on_delete: :nullify }
      t.bigint :entity_id, null: false
      t.text :entity_type, null: false
      t.integer :action_type, null: false
      t.jsonb :details, null: false
      t.inet :ip_address
      t.bigint :target_id, null: false
      t.text :target_type, null: false

      t.timestamps_with_timezone
    end
  end
end
