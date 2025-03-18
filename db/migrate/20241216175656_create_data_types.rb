# frozen_string_literal: true

class CreateDataTypes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :data_types do |t|
      t.references :namespace, index: false
      t.text :identifier, null: false, limit: 50
      t.integer :variant, null: false

      t.index %i[namespace_id identifier], unique: true

      t.timestamps_with_timezone
    end
  end
end
