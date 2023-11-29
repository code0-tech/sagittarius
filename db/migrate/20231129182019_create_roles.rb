# frozen_string_literal: true

class CreateRoles < Sagittarius::Database::Migration[1.0]
  def change
    create_table :roles do |t|
      t.text :name, limit: 50
      t.belongs_to :team, null: false, foreign_key: true

      t.timestamps_with_timezone

      t.index %i[team_id name], unique: true
    end
  end
end
