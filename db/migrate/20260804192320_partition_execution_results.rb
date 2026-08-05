# frozen_string_literal: true

class PartitionExecutionResults < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_partition_by_date_table :p_execution_results, partition_column: :created_at do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :cascade }, index: false
      t.text :execution_identifier, null: false, limit: 200
      t.jsonb :input
      t.bigint :started_at, null: false
      t.bigint :finished_at, null: false
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:p_execution_results, :result, :at_most_one)

      t.index :execution_identifier, name: 'idx_p_execution_results_on_identifier'

      t.timestamps_with_timezone
    end

    create_partition_by_date_table :p_execution_node_results, partition_column: :created_at do |t|
      t.references :execution_result, null: false, foreign_key: false, index: false
      t.references :node_function,
                   null: true,
                   foreign_key: { to_table: :node_functions, on_delete: :nullify }
      t.references :function_definition,
                   null: true,
                   foreign_key: { to_table: :function_definitions, on_delete: :nullify }
      t.integer :position, null: false
      t.bigint :started_at, null: false
      t.bigint :finished_at, null: false
      t.jsonb :success
      t.jsonb :error

      t.index %i[created_at execution_result_id position],
              unique: true,
              name: 'idx_p_exec_node_results_on_execution_id_and_position'

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:p_execution_node_results, :result, :at_most_one)

      t.timestamps_with_timezone
    end

    add_foreign_key :p_execution_node_results, :p_execution_results,
                    column: %i[execution_result_id created_at],
                    primary_key: %i[id created_at],
                    on_delete: :cascade

    create_partition_by_date_table :p_execution_parameter_results, partition_column: :created_at do |t|
      t.references :execution_node_result, null: false, foreign_key: false, index: false
      t.integer :position, null: false
      t.jsonb :value

      t.index %i[created_at execution_node_result_id position],
              unique: true,
              name: 'idx_p_exec_param_results_on_node_result_id_and_position'

      t.timestamps_with_timezone
    end

    add_foreign_key :p_execution_parameter_results, :p_execution_node_results,
                    column: %i[execution_node_result_id created_at],
                    primary_key: %i[id created_at],
                    on_delete: :cascade

    drop_table :execution_parameter_results do |t|
      t.references :execution_node_result,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: false
      t.integer :position, null: false
      t.jsonb :value

      t.index %i[execution_node_result_id position],
              unique: true,
              name: 'idx_exec_param_results_on_node_result_id_and_position'

      t.timestamps_with_timezone
    end

    drop_table :execution_node_results do |t|
      t.references :execution_result, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :node_function,
                   null: true,
                   foreign_key: { to_table: :node_functions, on_delete: :nullify }
      t.references :function_definition,
                   null: true,
                   foreign_key: { to_table: :function_definitions, on_delete: :nullify }
      t.integer :position, null: false
      t.bigint :started_at, null: false
      t.bigint :finished_at, null: false
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:execution_node_results, :result, :at_most_one)

      t.index %i[execution_result_id position],
              unique: true,
              name: 'idx_exec_node_results_on_execution_id_and_position'

      t.timestamps_with_timezone
    end

    drop_table :execution_results do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :cascade }, index: false
      t.text :execution_identifier, null: false, limit: 200
      t.jsonb :input
      t.bigint :started_at, null: false
      t.bigint :finished_at, null: false
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:execution_results, :result, :at_most_one)

      t.index '"flow_id", LOWER("execution_identifier")',
              unique: true,
              name: 'idx_execution_results_on_flow_id_and_identifier'
      t.index :execution_identifier, name: 'idx_execution_results_on_identifier'

      t.timestamps_with_timezone
    end
  end
end
