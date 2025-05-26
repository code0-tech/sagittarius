# frozen_string_literal: true

class CreateFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :reference_values do |t|
      t.references :data_type_identifier, null: false, foreign_key: { to_table: :data_type_identifiers,
                                                                      on_delete: :restrict }
      t.integer :primary_level, null: false
      t.integer :secondary_level, null: false
      t.integer :tertiary_level, null: true

      t.timestamps_with_timezone
    end

    create_table :reference_paths do |t|
      t.text :path, null: true
      t.integer :array_index, null: true

      t.references :reference_value, null: false, foreign_key: { to_table: :reference_values,
                                                                 on_delete: :cascade }

      t.timestamps_with_timezone
    end

    create_table :node_functions do |t|
      t.references :runtime_function, null: false, foreign_key: { to_table: :runtime_function_definitions,
                                                                  on_delete: :cascade }
      t.references :next_node, null: true, foreign_key: { to_table: :node_functions, on_delete: :cascade }

      t.timestamps_with_timezone
    end

    create_table :node_parameters do |t|
      t.references :runtime_parameter, null: false, foreign_key: { to_table: :runtime_parameter_definitions,
                                                                   on_delete: :cascade }

      t.jsonb :literal_value, null: true
      t.references :reference_value, null: true, foreign_key: { to_table: :reference_values,
                                                                on_delete: :restrict }
      t.references :function_value, null: true, foreign_key: { to_table: :node_functions,
                                                               on_delete: :cascade }

      t.check_constraint '(num_nonnulls(literal_value, reference_value_id, function_value_id) = 1)',
                         name: check_constraint_name(:node_parameters, :value, :one_of)

      t.timestamps_with_timezone
    end

    create_table :flows do |t|
      t.references :project, null: false, foreign_key: { to_table: :namespace_projects,
                                                         on_delete: :cascade }
      t.references :flow_type, null: false, foreign_key: { to_table: :flow_types, on_delete: :cascade }

      t.references :input_type_identifier, null: true, foreign_key: { to_table: :data_type_identifiers,
                                                                      on_delete: :restrict }
      t.references :return_type_identifier, null: true, foreign_key: { to_table: :data_type_identifiers,
                                                                       on_delete: :restrict }

      t.references :starting_node, null: false, foreign_key: { to_table: :node_functions, on_delete: :restrict }

      t.timestamps_with_timezone
    end

    add_reference :data_types, :flows, null: true, foreign_key: { to_table: :flows, on_delete: :restrict }

    create_table :flow_setting_definitions do |t|
      t.text :identifier, null: false
      t.text :key, null: false

      t.timestamps_with_timezone
    end

    create_table :flow_settings do |t|
      t.references :flow, null: true, foreign_key: { to_table: :flows, on_delete: :cascade }

      t.references :definition, null: false, foreign_key: { to_table: :flow_setting_definitions, on_delete: :cascade }
      t.jsonb :object, null: false

      t.timestamps_with_timezone
    end
  end
end
