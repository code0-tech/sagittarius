# frozen_string_literal: true

class LinkNodeParametersToParameterDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :node_parameters, :parameter_definition, null: false, foreign_key: { on_delete: :restrict }
    # rubocop:enable Rails/NotNullColumn
    remove_reference :node_parameters, :runtime_parameter, null: false, foreign_key: {
      on_delete: :cascade,
      to_table: :runtime_parameter_definitions,
    }
  end
end
