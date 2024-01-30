# frozen_string_literal: true

class CreateTeamMemberRoles < Sagittarius::Database::Migration[1.0]
  def change
    create_table :team_member_roles do |t|
      t.references :role, null: false, foreign_key: { to_table: :team_roles }
      t.references :member, null: false, foreign_key: { to_table: :team_members }

      t.timestamps_with_timezone
    end
  end
end
