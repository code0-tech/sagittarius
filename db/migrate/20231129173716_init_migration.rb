# frozen_string_literal: true

class InitMigration < Sagittarius::Database::Migration[1.0]
  def change
    # no-op -- first migration is empty to have a version that roll back the entire database
  end
end
