# frozen_string_literal: true

class CreateExecutionResults < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :execution_results do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :cascade }, index: false
      t.text :execution_identifier, null: false, limit: 200
      t.jsonb :input
      t.datetime_with_timezone :started_at, null: false
      t.datetime_with_timezone :finished_at, null: false
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

    create_table :execution_node_results do |t|
      t.references :execution_result, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :node_function,
                   null: true,
                   foreign_key: { to_table: :node_functions, on_delete: :nullify }
      t.integer :position, null: false
      t.datetime_with_timezone :started_at, null: false
      t.datetime_with_timezone :finished_at, null: false
      t.jsonb :success
      t.jsonb :error

      t.check_constraint 'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:execution_node_results, :result, :at_most_one)

      t.index %i[execution_result_id position],
              unique: true,
              name: 'idx_exec_node_results_on_execution_id_and_position'

      t.timestamps_with_timezone
    end

    create_table :execution_parameter_results do |t|
      t.references :execution_node_result,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: false
      t.integer :position, null: false
      t.jsonb :value, null: false

      t.index %i[execution_node_result_id position],
              unique: true,
              name: 'idx_exec_param_results_on_node_result_id_and_position'

      t.timestamps_with_timezone
    end
  end
end
