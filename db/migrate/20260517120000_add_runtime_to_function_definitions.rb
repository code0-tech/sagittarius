# frozen_string_literal: true

class AddRuntimeToFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :function_definitions, :runtime, foreign_key: { on_delete: :cascade }, index: false

    remove_index :function_definitions,
                 column: %i[runtime_module_id identifier],
                 unique: true,
                 name: 'idx_function_definitions_on_module_id_identifier'

    add_index :function_definitions,
              %i[runtime_id identifier],
              unique: true,
              name: 'idx_function_definitions_on_runtime_id_identifier'
  end
end
