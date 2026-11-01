# frozen_string_literal: true

class AddSubFlowFunctionResultToExecutionResults < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # NodeParameterNodeExecutionResult became NodeValueExecutionResult, a oneof of a
    # raw value (kept in `value`) or a sub-flow function result.
    add_column :p_execution_parameter_results, :sub_flow_function_result, :jsonb

    # NodeExecutionResult.success is now a NodeValueExecutionResult too: a raw value
    # (kept in `success`) or a sub-flow function result.
    add_column :p_execution_node_results, :success_sub_flow_function_result, :jsonb

    remove_check_constraint :p_execution_node_results,
                            'num_nonnulls(success, error) <= 1',
                            name: check_constraint_name(:p_execution_node_results, :result, :at_most_one)
    add_check_constraint :p_execution_node_results,
                         'num_nonnulls(success, error, success_sub_flow_function_result) <= 1',
                         name: check_constraint_name(:p_execution_node_results, :result, :at_most_one)
  end
end
