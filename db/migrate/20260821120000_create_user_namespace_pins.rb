# frozen_string_literal: true

class CreateUserNamespacePins < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :user_namespace_pins do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :namespace, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.integer :priority, null: false

      t.index %i[user_id namespace_id], unique: true
      t.index %i[user_id priority], unique: true

      t.timestamps_with_timezone
    end
  end
end
