# frozen_string_literal: true

class CreateOrganizationProjects < Sagittarius::Database::Migration[1.0]
  def change
    create_table :organization_projects do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }
      t.text :name, null: false, limit: 50, unique: { case_insensitive: true }
      t.text :description, null: false, default: '', limit: 500

      t.timestamps_with_timezone
    end
  end
end
