# frozen_string_literal: true

class CreateRuntimeParameterDefinitions < Sagittarius::Database::Migration[1.0]
  def change
    create_table :runtime_parameter_definitions do |t|
      t.references :runtime_function_definition, index: false, null: false, foreign_key: { on_delete: :cascade }
      t.references :data_type, null: false, foreign_key: { on_delete: :restrict }
      t.text :name, null: false, limit: 50

      t.index %i[runtime_function_definition_id name], unique: true

      t.timestamps_with_timezone
    end
  end
end
