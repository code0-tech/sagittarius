# frozen_string_literal: true

class AddStatusToRuntime < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtimes, :status, :integer
  end
end
