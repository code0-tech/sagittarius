# frozen_string_literal: true

class AddDisabledReasontoFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :disabled_reason, :text, null: true, default: nil
    add_index :flows, :disabled_reason, length: 100
  end
end
