# frozen_string_literal: true

class CreateOrganizations < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :organizations do |t|
      t.text :name, null: false, limit: 50, unique: { case_insensitive: true }

      t.timestamps_with_timezone
    end
  end
end
