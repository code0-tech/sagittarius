# frozen_string_literal: true

class CreatePermissions < Sagittarius::Database::Migration[1.0]
  def change
    create_table :permissions do |t|
      t.text :name, limit: 50, unique: { case_insensitive: true }
      t.text :description
      t.integer :permission_type

      t.timestamps_with_timezone
    end
  end
end
