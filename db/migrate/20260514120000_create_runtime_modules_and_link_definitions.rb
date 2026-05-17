# frozen_string_literal: true

class CreateRuntimeModulesAndLinkDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    create_table :runtime_modules do |t|
      t.references :runtime, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :identifier, null: false, limit: 50
      t.text :documentation, null: false, default: '', limit: 200
      t.text :author, null: false, default: '', limit: 200
      t.text :icon, limit: 100
      t.text :version, null: false

      t.index %i[runtime_id identifier], unique: true, name: 'idx_runtime_modules_on_runtime_id_identifier'

      t.timestamps_with_timezone
    end

    create_table :module_configuration_definitions do |t|
      t.references :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :identifier, null: false, limit: 50
      t.text :type, null: false, limit: 2000
      t.jsonb :default_value
      t.boolean :optional, null: false, default: false
      t.boolean :hidden, null: false, default: false

      t.index %i[runtime_module_id identifier], unique: true, name: 'idx_module_configs_on_module_id_identifier'

      t.timestamps_with_timezone
    end

    create_table :module_configuration_definition_data_type_links do |t|
      t.references :module_configuration_definition, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :referenced_data_type, null: false, foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[module_configuration_definition_id referenced_data_type_id],
              unique: true,
              name: 'idx_module_config_links_on_config_id_data_type_id'

      t.timestamps_with_timezone
    end

    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :data_types, :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
    add_reference :flow_types, :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
    add_reference :runtime_function_definitions,
                  :runtime_module,
                  null: false,
                  foreign_key: { on_delete: :cascade },
                  index: false
    # rubocop:enable Rails/NotNullColumn

    add_index :data_types,
              %i[runtime_module_id identifier],
              unique: true,
              name: 'idx_data_types_on_runtime_module_id_identifier'
    add_index :flow_types,
              %i[runtime_module_id identifier],
              unique: true,
              name: 'idx_flow_types_on_runtime_module_id_identifier'
    add_index :runtime_function_definitions,
              %i[runtime_module_id runtime_name],
              unique: true,
              name: 'idx_rfd_on_runtime_module_id_runtime_name'
  end

  def down
    remove_index :runtime_function_definitions, name: 'idx_rfd_on_runtime_module_id_runtime_name'
    remove_index :flow_types, name: 'idx_flow_types_on_runtime_module_id_identifier'
    remove_index :data_types, name: 'idx_data_types_on_runtime_module_id_identifier'

    remove_reference :runtime_function_definitions, :runtime_module, foreign_key: { on_delete: :cascade }
    remove_reference :flow_types, :runtime_module, foreign_key: { on_delete: :cascade }
    remove_reference :data_types, :runtime_module, foreign_key: { on_delete: :cascade }

    drop_table :module_configuration_definition_data_type_links
    drop_table :module_configuration_definitions
    drop_table :runtime_modules
  end
end
