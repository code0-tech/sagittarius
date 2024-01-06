# frozen_string_literal: true

class CreateTeamRoles < Sagittarius::Database::Migration[1.0]
  def change
    create_table :team_roles do |t|
      t.references :team, null: false, foreign_key: true
      t.text :name, null: false

      t.index '"team_id", LOWER("name")', unique: true

      t.timestamps_with_timezone
    end
  end
end
