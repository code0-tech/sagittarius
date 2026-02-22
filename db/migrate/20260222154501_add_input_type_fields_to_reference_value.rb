# frozen_string_literal: true

class AddInputTypeFieldsToReferenceValue < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :reference_values, :parameter_index, :int
    add_column :reference_values, :input_index, :int

    add_check_constraint :reference_values, 'num_nonnulls(parameter_index, input_index) IN (0, 2)',
                         name: check_constraint_name(:reference_values, :indexes, :none_or_both)

    change_column_null :reference_values, :node_function_id, true
  end
end
