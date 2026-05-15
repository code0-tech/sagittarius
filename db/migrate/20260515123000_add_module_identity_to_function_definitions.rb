# frozen_string_literal: true

class AddModuleIdentityToFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :function_definitions, :runtime_module, foreign_key: { on_delete: :cascade }, index: false
    add_column :function_definitions, :identifier, :text, limit: 50
    add_column :function_definitions, :removed_at, :timestamptz

    add_index :function_definitions,
              %i[runtime_module_id identifier],
              unique: true,
              name: 'idx_function_definitions_on_module_id_identifier'
  end
end
