# frozen_string_literal: true

class CreateTeamMemberRoles < Sagittarius::Database::Migration[1.0]
  def change
    create_table :team_member_roles do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps_with_timezone

      t.index %i[team_member_id role_id], unique: true
    end
  end
end
