# frozen_string_literal: true

class CreateFlowTypeSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :flow_type_settings do |t|
      t.references :flow_type, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.text :identifier, null: false
      t.boolean :unique, null: false, default: false
      t.references :data_type, foreign_key: { on_delete: :restrict }, null: false
      t.jsonb :default_value

      t.index %i[flow_type_id identifier], unique: true

      t.timestamps_with_timezone
    end
  end
end
