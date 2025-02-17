# frozen_string_literal: true

class CreateApplicationSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :application_settings do |t|
      t.integer :setting, null: false, unique: true
      t.jsonb :value, null: false

      t.timestamps_with_timezone
    end
  end
end
