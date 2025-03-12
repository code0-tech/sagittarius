# frozen_string_literal: true

class CreateBackupCodes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :backup_codes do |t|
      t.text :token, limit: 10, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false

      t.index '"user_id", LOWER("token")', unique: true

      t.timestamps_with_timezone
    end
  end
end
