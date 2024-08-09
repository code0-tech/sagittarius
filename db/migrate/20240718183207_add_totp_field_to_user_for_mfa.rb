# frozen_string_literal: true

class AddTotpFieldToUserForMfa < Sagittarius::Database::Migration[1.0]
  def change
    add_column :users, :totp_secret, :text, unique: { allow_nil_duplicate: true }
  end
end
