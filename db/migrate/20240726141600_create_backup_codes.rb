# frozen_string_literal: true

class CreateBackupCodes < Sagittarius::Database::Migration[1.0]
  def change
    create_table :backup_codes do |t|
      t.text :token, limit: 10
      t.references :user, null: false, foreign_key: true

      t.index '"user_id", LOWER("token")', unique: true

      t.timestamps_with_timezone
    end
  end
end
