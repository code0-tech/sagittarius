# frozen_string_literal: true

class CreateRolePolicies < Sagittarius::Database::Migration[1.0]
  def change
    create_table :role_policies do |t|
      t.belongs_to :policy, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps_with_timezone

      t.index %i[policy_id role_id], unique: true
    end
  end
end
