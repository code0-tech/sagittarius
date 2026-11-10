# frozen_string_literal: true

class AddSubFlowIdentifierToExecutionNodeResults < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # NodeExecutionResult.id gained a third variant, subflow_identifier, identifying
    # sub-flow executions that only live in the runtime and have no persisted record.
    add_column :p_execution_node_results, :sub_flow_identifier, :text
  end
end
