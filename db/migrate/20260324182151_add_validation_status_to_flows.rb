# frozen_string_literal: true

class AddValidationStatusToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :validation_status, :integer, null: false, default: 0
  end
end
