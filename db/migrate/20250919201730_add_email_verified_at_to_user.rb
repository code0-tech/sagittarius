# frozen_string_literal: true

class AddEmailVerifiedAtToUser < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :email_verified_at, :datetime_with_timezone
  end
end
