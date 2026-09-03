# frozen_string_literal: true

class LinkNodeFunctionsToFunctionDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable-next Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :node_functions, :function_definition, null: false, foreign_key: { on_delete: :restrict }
    remove_reference :node_functions, :runtime_function, null: false, foreign_key: {
      on_delete: :restrict,
      to_table: :runtime_function_definitions,
    }
  end
end
