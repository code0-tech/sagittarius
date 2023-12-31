# frozen_string_literal: true

class CreateTeamMembers < Sagittarius::Database::Migration[1.0]
  def change
    create_table :team_members do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.index %i[team_id user_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
