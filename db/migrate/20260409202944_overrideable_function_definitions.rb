# frozen_string_literal: true

class OverrideableFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :function_definitions, :removed_at, :datetime_with_timezone
    add_column :function_definitions, :runtime_name, :text, limit: 50
    add_column :function_definitions, :runtime_definition_name, :text, limit: 50
    add_column :function_definitions, :version, :text
    add_column :function_definitions, :definition_source, :text, limit: 50
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_column :function_definitions, :signature, :text, null: false, limit: 500
    # rubocop:enable Rails/NotNullColumn
    add_column :function_definitions, :throws_error, :boolean, default: false, null: false
    add_column :function_definitions, :display_icon, :text, limit: 100

    add_column :parameter_definitions, :runtime_name, :text
    add_column :parameter_definitions, :removed_at, :datetime_with_timezone
    add_column :parameter_definitions, :runtime_definition_name, :text, limit: 50

    create_table :function_definition_data_type_links do |t|
      t.references :function_definition, null: false,
                                         foreign_key: { on_delete: :cascade },
                                         index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[function_definition_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
