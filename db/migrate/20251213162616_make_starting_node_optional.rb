# frozen_string_literal: true

class MakeStartingNodeOptional < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    change_column_null :flows, :starting_node_id, true
    remove_foreign_key :flows, :node_functions, column: :starting_node_id
    add_foreign_key :flows, :node_functions, column: :starting_node_id, on_delete: :nullify
  end
end
