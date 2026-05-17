# frozen_string_literal: true

class AddRuntimeToFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    unless column_exists?(:function_definitions, :runtime_id)
      add_reference :function_definitions, :runtime, foreign_key: { on_delete: :cascade }, index: false
    end

    remove_index :function_definitions, name: 'idx_function_definitions_on_module_id_identifier',
                                        if_exists: true
    add_index :function_definitions,
              %i[runtime_id identifier],
              unique: true,
              name: 'idx_function_definitions_on_runtime_id_identifier',
              if_not_exists: true
  end
end
