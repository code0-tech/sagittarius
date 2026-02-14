# frozen_string_literal: true

class MakeNodeFunctionConstraintsDeferrable < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :reference_values,
                       :node_functions,
                       on_delete: :restrict

    add_foreign_key :reference_values,
                    :node_functions,
                    deferrable: :deferred

    remove_foreign_key :node_functions,
                       :node_functions,
                       column: :next_node_id,
                       on_delete: :restrict

    add_foreign_key :node_functions,
                    :node_functions,
                    column: :next_node_id,
                    deferrable: :deferred
  end
end
