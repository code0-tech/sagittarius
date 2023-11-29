# frozen_string_literal: true

class CreateTeamMembers < Sagittarius::Database::Migration[1.0]
  def change
    create_table :team_members do |t|
      t.belongs_to :team, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps_with_timezone

      t.index %i[team_id user_id], unique: true
    end
  end
end
