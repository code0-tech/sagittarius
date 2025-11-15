# frozen_string_literal: true

class AddDepthNodeScopeToRefValues < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :reference_values, :depth, :integer, null: false, default: 0
    add_column :reference_values, :node, :integer, null: false, default: 0
    add_column :reference_values, :scope, :integer, array: true, null: false, default: []

    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :reference_values, :data_type_identifier, null: false, foreign_key: {
      to_table: :data_type_identifiers, on_delete: :restrict
    }
    # rubocop:enable Rails/NotNullColumn
  end
end
