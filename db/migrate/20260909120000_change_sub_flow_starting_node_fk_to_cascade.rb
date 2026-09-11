# frozen_string_literal: true

class ChangeSubFlowStartingNodeFkToCascade < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :sub_flows, :node_functions, column: :starting_node_id, on_delete: :restrict

    add_foreign_key :sub_flows,
                    :node_functions,
                    column: :starting_node_id,
                    deferrable: :deferred
  end
end
