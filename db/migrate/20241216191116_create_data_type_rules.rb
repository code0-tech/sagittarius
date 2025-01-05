# frozen_string_literal: true

class CreateDataTypeRules < Sagittarius::Database::Migration[1.0]
  def change
    create_table :data_type_rules do |t|
      t.references :data_type, null: false, foreign_key: { on_delete: :cascade }
      t.integer :variant, null: false
      t.jsonb :config, null: false

      t.timestamps_with_timezone
    end
  end
end
