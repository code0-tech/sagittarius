# frozen_string_literal: true

class AllowAllNullValuesInNodeParameter < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_check_constraint :node_parameters,
                         '(num_nonnulls(literal_value, reference_value_id, function_value_id) <= 1)',
                         name: check_constraint_name(:node_parameters, :value, :at_most_one)

    remove_check_constraint :node_parameters,
                            '(num_nonnulls(literal_value, reference_value_id, function_value_id) = 1)',
                            name: check_constraint_name(:node_parameters, :value, :one_of)
  end
end
