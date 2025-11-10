# frozen_string_literal: true

class SimplifyReferenceValue < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_reference :reference_values, :data_type_identifier, index: true

    remove_column :reference_values, :primary_level, :integer
    remove_column :reference_values, :secondary_level, :integer
    remove_column :reference_values, :tertiary_level, :integer

    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :reference_values, :node_function, null: false, foreign_key: {
      to_table: :node_functions, on_delete: :restrict
    }
    # rubocop:enable Rails/NotNullColumn
  end
end
