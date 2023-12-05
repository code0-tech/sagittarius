# frozen_string_literal: true

class CreateUserSessions < Sagittarius::Database::Migration[1.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.text :token, unique: true, null: false
      t.boolean :active, default: true, null: false

      t.timestamps_with_timezone
    end
  end
end
