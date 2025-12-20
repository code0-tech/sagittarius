# frozen_string_literal: true

class AddLastExecutionDurationToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :last_execution_duration, :bigint, null: true, default: nil
  end
end
