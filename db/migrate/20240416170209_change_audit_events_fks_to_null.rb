# frozen_string_literal: true

class ChangeAuditEventsFksToNull < Sagittarius::Database::Migration[1.0]
  def change
    remove_foreign_key :audit_events, :users, column: :author_id
    add_foreign_key :audit_events, :users, column: :author_id, on_delete: :nullify
  end
end
