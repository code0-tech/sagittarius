# frozen_string_literal: true

class CreateOrganizationMemberRoles < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :organization_member_roles do |t|
      t.references :role, null: false, foreign_key: { to_table: :organization_roles }
      t.references :member, null: false, foreign_key: { to_table: :organization_members }

      t.timestamps_with_timezone
    end
  end
end
