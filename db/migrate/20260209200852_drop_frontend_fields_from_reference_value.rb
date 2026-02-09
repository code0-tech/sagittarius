# frozen_string_literal: true

class DropFrontendFieldsFromReferenceValue < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_reference :reference_values, :data_type_identifier, null: false, foreign_key: {
      to_table: :data_type_identifiers, on_delete: :restrict
    }

    remove_column :reference_values, :scope, :integer, array: true, null: false, default: []
    remove_column :reference_values, :node, :integer, null: false, default: 0
    remove_column :reference_values, :depth, :integer, null: false, default: 0
  end
end
