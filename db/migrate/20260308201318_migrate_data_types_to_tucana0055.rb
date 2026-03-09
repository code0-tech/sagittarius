# frozen_string_literal: true

class MigrateDataTypesToTucana0055 < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # Cleanup of old data types
    remove_check_constraint :data_type_identifiers, '(num_nonnulls(generic_key, data_type_id, generic_type_id) = 1)',
                            name: check_constraint_name(:data_type_identifiers, :type, :one_of)

    remove_reference :runtime_function_definitions, :return_type,
                     foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict },
                     null: true
    remove_reference :runtime_parameter_definitions, :data_type,
                     foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict },
                     null: true
    remove_reference :parameter_definitions, :data_type,
                     foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict },
                     null: true
    remove_reference :function_definitions, :return_type,
                     foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict },
                     null: true
    remove_reference :data_types, :parent_type,
                     foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict },
                     null: true

    remove_reference :data_type_identifiers, :generic_type,
                     foreign_key: { to_table: :generic_types, on_delete: :cascade },
                     null: true

    remove_reference :flow_type_settings, :data_type,
                     foreign_key: { on_delete: :restrict },
                     null: false

    remove_reference :flow_types, :input_type,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    remove_reference :flow_types, :return_type,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }

    remove_reference :flows, :input_type,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    remove_reference :flows, :return_type,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }

    remove_column :runtime_function_definitions, :generic_keys, 'text[]', null: false, default: []

    remove_column :data_types, :variant, :integer, null: false

    drop_table :generic_combination_strategies do |t|
      t.integer :type, null: false
      t.references :generic_mapper, null: true, foreign_key: {
        to_table: :generic_mappers,
        on_delete: :cascade,
      }

      t.timestamps_with_timezone
    end

    remove_reference :data_type_identifiers, :generic_mapper,
                     foreign_key: { to_table: :generic_mappers, on_delete: :cascade },
                     null: true

    drop_table :generic_mappers do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }

      t.text :target, null: false
      t.references :generic_type, null: true, foreign_key: { to_table: :generic_types, on_delete: :restrict }

      t.timestamps_with_timezone
    end

    drop_table :generic_types do |t|
      t.references :data_type, null: false, foreign_key: { to_table: :data_types, on_delete: :cascade }

      t.timestamps_with_timezone

      t.references :owner, polymorphic: true
    end

    drop_table :data_type_identifiers do |t|
      t.text :generic_key, null: true
      t.references :data_type, null: true, foreign_key: { to_table: :data_types, on_delete: :restrict }

      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    # Creation of tables and relations for the new data types
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_column :runtime_function_definitions, :signature, :text, null: false, limit: 500
    add_column :data_types, :type, :text, null: false, limit: 2000
    add_column :flow_type_settings, :type, :text, null: false, limit: 2000
    add_column :flow_types, :input_type, :text, limit: 2000
    add_column :flow_types, :return_type, :text, limit: 2000
    add_column :flows, :input_type, :text, limit: 2000
    add_column :flows, :return_type, :text, limit: 2000
    # rubocop:enable Rails/NotNullColumn

    create_table :runtime_function_definition_data_type_links do |t|
      t.references :runtime_function_definition, null: false,
                                                 foreign_key: { on_delete: :cascade },
                                                 index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[runtime_function_definition_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end

    create_table :data_type_data_type_links do |t|
      t.references :data_type, null: false,
                               foreign_key: { on_delete: :cascade },
                               index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[data_type_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end

    create_table :flow_type_setting_data_type_links do |t|
      t.references :flow_type_setting, null: false,
                                       foreign_key: { on_delete: :cascade },
                                       index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[flow_type_setting_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end

    create_table :flow_type_data_type_links do |t|
      t.references :flow_type, null: false,
                               foreign_key: { on_delete: :cascade },
                               index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[flow_type_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end

    create_table :flow_data_type_links do |t|
      t.references :flow, null: false,
                          foreign_key: { on_delete: :cascade },
                          index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[flow_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
