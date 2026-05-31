# frozen_string_literal: true

class CreateTestExecutions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :test_executions do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :cascade }, index: false
      t.text :execution_identifier, null: false, limit: 200
      t.jsonb :body
      t.jsonb :input
      t.datetime_with_timezone :started_at
      t.datetime_with_timezone :finished_at
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:test_executions, :result, :at_most_one)

      t.index %i[flow_id execution_identifier],
              unique: true,
              name: 'idx_test_executions_on_flow_id_and_identifier'
      t.index :execution_identifier, name: 'idx_test_executions_on_identifier'

      t.timestamps_with_timezone
    end

    create_table :test_execution_node_results do |t|
      t.references :test_execution, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :node_function,
                   null: true,
                   foreign_key: { to_table: :node_functions, on_delete: :nullify },
                   index: false
      t.bigint :node_id, null: false
      t.integer :position, null: false
      t.datetime_with_timezone :started_at
      t.datetime_with_timezone :finished_at
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:test_execution_node_results, :result, :at_most_one)

      t.index %i[test_execution_id position],
              unique: true,
              name: 'idx_test_exec_node_results_on_execution_id_and_position'
      t.index :node_function_id, name: 'idx_test_exec_node_results_on_node_function_id'

      t.timestamps_with_timezone
    end

    create_table :test_execution_parameter_results do |t|
      t.references :test_execution_node_result,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: { name: 'idx_test_exec_param_results_on_node_result_id' }
      t.integer :position, null: false
      t.jsonb :value, null: false

      t.index %i[test_execution_node_result_id position],
              unique: true,
              name: 'idx_test_exec_param_results_on_node_result_id_and_position'

      t.timestamps_with_timezone
    end
  end
end
