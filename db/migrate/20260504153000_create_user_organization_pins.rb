# frozen_string_literal: true

class CreateUserOrganizationPins < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :user_organization_pins do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.integer :priority, null: false

      t.index %i[user_id organization_id], unique: true
      t.index %i[user_id priority], unique: true

      t.timestamps_with_timezone
    end
  end
end
