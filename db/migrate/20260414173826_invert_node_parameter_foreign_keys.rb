# frozen_string_literal: true

class InvertNodeParameterForeignKeys < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_check_constraint :node_parameters,
                            '(num_nonnulls(literal_value, reference_value_id, function_value_id) <= 1)',
                            name: check_constraint_name(:node_parameters, :value, :at_most_one)

    remove_reference :node_parameters, :reference_value,
                     null: true,
                     foreign_key: { to_table: :reference_values, on_delete: :cascade }

    remove_reference :node_parameters, :function_value,
                     null: true,
                     foreign_key: { to_table: :node_functions, deferrable: :deferred }

    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :reference_values, :node_parameter,
                  null: false,
                  foreign_key: { to_table: :node_parameters, on_delete: :cascade }
    # rubocop:enable Rails/NotNullColumn

    add_reference :node_functions, :value_of_node_parameter,
                  null: true,
                  foreign_key: { to_table: :node_parameters, on_delete: :cascade }
  end
end
