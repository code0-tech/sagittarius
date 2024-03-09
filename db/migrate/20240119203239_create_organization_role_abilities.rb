# frozen_string_literal: true

class CreateOrganizationRoleAbilities < Sagittarius::Database::Migration[1.0]
  def change
    create_table :organization_role_abilities do |t|
      t.references :team_role, null: false, foreign_key: true
      t.integer :ability, null: false

      t.index %i[team_role_id ability], unique: true

      t.timestamps_with_timezone
    end
  end
end
