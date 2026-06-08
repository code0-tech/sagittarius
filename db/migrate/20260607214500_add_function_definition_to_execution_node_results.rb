# frozen_string_literal: true

class AddFunctionDefinitionToExecutionNodeResults < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :execution_node_results,
                  :function_definition,
                  null: true,
                  foreign_key: { to_table: :function_definitions, on_delete: :nullify }
  end
end
