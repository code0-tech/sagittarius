# frozen_string_literal: true

class AddRuntimeToFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :function_definitions, :runtime, null: false, foreign_key: { on_delete: :cascade }, index: false
    # rubocop:enable Rails/NotNullColumn

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
