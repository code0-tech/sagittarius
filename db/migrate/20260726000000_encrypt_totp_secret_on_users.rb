# frozen_string_literal: true

class EncryptTotpSecretOnUsers < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    remove_index :users, :totp_secret, name: 'index_users_on_totp_secret'
  end

  def down
    add_index :users, :totp_secret, unique: true, where: 'totp_secret IS NOT NULL',
                                    name: 'index_users_on_totp_secret'
  end
end
