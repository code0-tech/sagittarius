# frozen_string_literal: true

class RemoveSignatureFromFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_column :flows, :signature, :text
  end
end
