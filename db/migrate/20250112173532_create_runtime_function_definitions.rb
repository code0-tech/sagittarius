# frozen_string_literal: true

class CreateRuntimeFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_function_definitions do |t|
      t.references :return_type, null: true, foreign_key: { to_table: :data_types, on_delete: :restrict }
      t.references :runtime, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.text :runtime_name, null: false, limit: 50

      t.datetime_with_timezone :removed_at, null: true

      t.index %i[runtime_id runtime_name], unique: true

      t.timestamps_with_timezone
    end
  end
end
