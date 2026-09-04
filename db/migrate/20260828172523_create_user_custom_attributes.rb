# frozen_string_literal: true

class CreateUserCustomAttributes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :user_custom_attributes do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :key, null: false, limit: 255
      t.jsonb :value, null: false

      t.timestamps_with_timezone

      t.index %i[user_id key], unique: true
    end
  end
end
