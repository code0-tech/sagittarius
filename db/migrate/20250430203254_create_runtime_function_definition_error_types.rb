# frozen_string_literal: true

class CreateRuntimeFunctionDefinitionErrorTypes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_function_definition_error_types do |t|
      t.references :runtime_function_definition, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :data_type, null: false, foreign_key: { on_delete: :restrict }, index: false

      t.index %i[runtime_function_definition_id data_type_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
