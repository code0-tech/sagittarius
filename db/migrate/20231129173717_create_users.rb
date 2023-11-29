# frozen_string_literal: true

class CreateUsers < Sagittarius::Database::Migration[1.0]
  def change
    create_table :users do |t|
      t.text :username, limit: 50, unique: { case_insensitive: true }
      t.text :email, limit: 255, unique: { case_insensitive: true }
      t.text :firstname
      t.text :lastname
      t.text :password_digest, null: false

      t.timestamps_with_timezone
    end
  end
end
