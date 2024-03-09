# frozen_string_literal: true

class CreateOrganizationMembers < Sagittarius::Database::Migration[1.0]
  def change
    create_table :organization_members do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.index %i[organization_id user_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
