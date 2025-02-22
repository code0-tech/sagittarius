# frozen_string_literal: true

class CreateOrganizationRoleAbilities < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :organization_role_abilities do |t|
      t.references :organization_role, null: false, foreign_key: true
      t.integer :ability, null: false

      t.index %i[organization_role_id ability], unique: true

      t.timestamps_with_timezone
    end
  end
end
