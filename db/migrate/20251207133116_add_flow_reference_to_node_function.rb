# frozen_string_literal: true

class AddFlowReferenceToNodeFunction < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- We currently dont care about backwards compatibility
    add_reference :node_functions, :flow, foreign_key: { to_table: :flows, on_delete: :cascade }, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
