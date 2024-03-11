# frozen_string_literal: true

class CreateOrganizationRoles < Sagittarius::Database::Migration[1.0]
  def change
    create_table :organization_roles do |t|
      t.references :organization, null: false, foreign_key: true
      t.text :name, null: false

      t.index '"organization_id", LOWER("name")', unique: true

      t.timestamps_with_timezone
    end
  end
end
