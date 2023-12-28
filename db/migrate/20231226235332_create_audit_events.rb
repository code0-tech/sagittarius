# frozen_string_literal: true

class CreateAuditEvents < Sagittarius::Database::Migration[1.0]
  def change
    create_table :audit_events do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.integer :entity_id, null: false
      t.text :entity_type, null: false
      t.integer :action_type, null: false
      t.jsonb :details, null: false
      t.inet :ip_address
      t.integer :target_id, null: false
      t.text :target_type, null: false

      t.timestamps_with_timezone
    end
  end
end
