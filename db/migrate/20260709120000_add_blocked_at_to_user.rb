# frozen_string_literal: true

class AddBlockedAtToUser < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :blocked_at, :datetime_with_timezone
  end
end
