# frozen_string_literal: true

class ChangeAuditEventIdsToBigint < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    change_column :audit_events, :entity_id, :bigint, null: false
    change_column :audit_events, :target_id, :bigint, null: false
  end

  def down
    change_column :audit_events, :entity_id, :integer, null: false
    change_column :audit_events, :target_id, :integer, null: false
  end
end
