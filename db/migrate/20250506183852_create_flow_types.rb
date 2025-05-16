# frozen_string_literal: true

class CreateFlowTypes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :flow_types do |t|
      t.references :runtime, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.text :identifier, null: false
      t.references :input_type, foreign_key: { to_table: :data_types, on_delete: :restrict }
      t.references :return_type, foreign_key: { to_table: :data_types, on_delete: :restrict }
      t.boolean :editable, null: false, default: true
      t.datetime_with_timezone :removed_at

      t.index %i[runtime_id identifier], unique: true

      t.timestamps_with_timezone
    end
  end
end
