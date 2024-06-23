# frozen_string_literal: true

class CreateRuntimes < Sagittarius::Database::Migration[1.0]
  def change
    create_table :runtimes do |t|
      t.text :name, null: false, limit: 50
      t.text :description, null: false, default: '', limit: 500
      t.text :token, unique: true, null: false
      t.references :namespace, null: true, foreign_key: true

      t.timestamps_with_timezone
    end
  end
end
