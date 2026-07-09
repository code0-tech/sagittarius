# frozen_string_literal: true

class AddValidationMessageToFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :validation_message, :text, array: true, null: false, default: []
  end
end
