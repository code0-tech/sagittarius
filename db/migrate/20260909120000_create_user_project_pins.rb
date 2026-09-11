# frozen_string_literal: true

class CreateUserProjectPins < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :user_project_pins do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :namespace, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :project, null: false, foreign_key: { to_table: :namespace_projects, on_delete: :cascade },
                             index: false
      t.integer :priority, null: false

      t.index %i[user_id project_id], unique: true
      t.index %i[user_id namespace_id priority], unique: true

      t.timestamps_with_timezone
    end
  end
end
