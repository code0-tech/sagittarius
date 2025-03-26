# frozen_string_literal: true

class CreateFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :function_definitions do |t|
      t.references :runtime_function_definition, null: false, foreign_key: { on_delete: :cascade }

      t.references :return_type, null: true, foreign_key: { to_table: :data_types, on_delete: :restrict }

      t.timestamps_with_timezone
    end
  end
end
