# frozen_string_literal: true

class CreateGoodJobSettings < Sagittarius::Database::Migration[1.0]
  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.table_exists?(:good_job_settings)
      end
    end

    create_table :good_job_settings, id: :uuid do |t|
      t.timestamps_with_timezone
      t.text :key
      t.jsonb :value
      t.index :key, unique: true
    end
  end
end
