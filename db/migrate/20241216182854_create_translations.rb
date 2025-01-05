# frozen_string_literal: true

class CreateTranslations < Sagittarius::Database::Migration[1.0]
  def change
    create_table :translations do |t|
      t.text :code, null: false
      t.text :content, null: false
      t.references :owner, polymorphic: true, null: false

      t.timestamps_with_timezone
    end
  end
end
