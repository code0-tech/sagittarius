# frozen_string_literal: true

class ImplementGenerics < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # See:
    # https://github.com/code0-tech/tucana/pull/93

    add_column :data_types, :generic_keys, 'text[]', null: false, default: []

    create_table :data_type_identifiers do |t|
      # One of them needs to be set will be enforced later
      t.text :generic_key, null: true
      t.references :data_type, null: true, foreign_key: { to_table: :data_types, on_delete: :restrict }

      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    create_table :generic_types do |t|
      t.references :data_type, null: false, foreign_key: { to_table: :data_types, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    create_table :generic_mappers do |t|
      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }

      t.text :target, null: false
      t.references :generic_type, null: true, foreign_key: { to_table: :generic_types, on_delete: :restrict }

      t.timestamps_with_timezone
    end

    add_reference :data_type_identifiers, :generic_type, null: true,
                                                         foreign_key: { to_table: :generic_types, on_delete: :cascade }

    add_check_constraint :data_type_identifiers, '(num_nonnulls(generic_key, data_type_id, generic_type_id) = 1)',
                         name: check_constraint_name(:data_type_identifiers, :type, :one_of)

    create_table :function_generic_mappers do |t|
      t.text :target, null: false
      t.references :runtime_parameter_definition, null: true,
                                                  foreign_key: { to_table: :runtime_parameter_definitions,
                                                                 on_delete: :restrict }

      t.references :runtime_function_definition, null: true,
                                                 foreign_key: { to_table: :runtime_function_definitions,
                                                                on_delete: :restrict }

      t.references :runtime, null: false, foreign_key: { to_table: :runtimes, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    remove_reference :runtime_function_definitions, :return_type,
                     null: true,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    add_reference :runtime_function_definitions, :return_type,
                  foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict }, null: true

    add_column :runtime_function_definitions, :generic_keys, 'text[]', null: false, default: []

    remove_reference :runtime_parameter_definitions, :data_type,
                     null: true,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    add_reference :runtime_parameter_definitions, :data_type,
                  foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict }, null: true

    remove_reference :parameter_definitions, :data_type,
                     null: true,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    add_reference :parameter_definitions, :data_type,
                  foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict }, null: true

    remove_reference :function_definitions, :return_type,
                     null: true,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }
    add_reference :function_definitions, :return_type,
                  foreign_key: { to_table: :data_type_identifiers, on_delete: :restrict }, null: true

    remove_reference :data_types, :parent_type,
                     null: true,
                     foreign_key: { to_table: :data_types, on_delete: :restrict }

    add_reference :data_types, :parent_type, null: true,
                                             foreign_key: { to_table: :data_type_identifiers,
                                                            on_delete: :restrict }

    add_reference :data_type_identifiers, :generic_mapper, null: true,
                                                           foreign_key: { to_table: :generic_mappers,
                                                                          on_delete: :restrict }
    add_reference :data_type_identifiers, :function_generic_mapper, null: true,
                                                                    foreign_key: { to_table: :function_generic_mappers,
                                                                                   on_delete: :restrict }
  end
end
