# frozen_string_literal: true

class AddTotpFieldToUserForMfa < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :totp_secret, :text, unique: { allow_nil_duplicate: true }
  end
end
