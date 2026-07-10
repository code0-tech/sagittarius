# frozen_string_literal: true

class AddValidationDiagnosticsToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :validation_diagnostics, :jsonb, null: false, default: []
  end
end
