# frozen_string_literal: true

class AllowNullExecutionResultValues < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    change_column_null :execution_parameter_results, :value, true

    remove_check_constraint :execution_results,
                            name: check_constraint_name(:execution_results, :result, :at_most_one)
    add_check_constraint :execution_results,
                         'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:execution_results, :result, :at_most_one)

    remove_check_constraint :execution_node_results,
                            name: check_constraint_name(:execution_node_results, :result, :at_most_one)
    add_check_constraint :execution_node_results,
                         'num_nonnulls(success, error) <= 1',
                         name: check_constraint_name(:execution_node_results, :result, :at_most_one)
  end
end
