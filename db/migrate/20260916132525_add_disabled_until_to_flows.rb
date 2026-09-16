# frozen_string_literal: true

class AddDisabledUntilToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :disabled_until, :date, null: true
  end
end
