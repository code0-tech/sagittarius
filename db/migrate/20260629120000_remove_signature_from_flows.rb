# frozen_string_literal: true

class RemoveSignatureFromFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    remove_column :flows, :signature
  end

  def down
    add_column :flows, :signature, :text, null: false, default: '', limit: 500
  end
end
