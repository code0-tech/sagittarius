# frozen_string_literal: true

class AddDisabledReasonToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :disabled_reason, :integer, null: true
  end
end
