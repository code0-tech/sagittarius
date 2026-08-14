# frozen_string_literal: true

class AddFlowInlineReferenceValues < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :inline_reference_values do |t|
      t.references :node_parameter, null: true, foreign_key: { to_table: :node_parameters, on_delete: :cascade }
      t.references :parent_inline_reference_value, null: true,
                                                   foreign_key: {
                                                     to_table: :inline_reference_values, on_delete: :cascade
                                                   }
      t.text :signature, null: false, limit: 500
      t.jsonb :literal_value

      t.check_constraint 'num_nonnulls(node_parameter_id, parent_inline_reference_value_id) = 1',
                         name: check_constraint_name(:inline_reference_values, :owner, :one_of)

      t.timestamps_with_timezone
    end

    change_column_null :reference_values, :node_parameter_id, true
    add_reference :reference_values, :inline_reference_value, null: true,
                                                              foreign_key: {
                                                                to_table: :inline_reference_values,
                                                                on_delete: :cascade,
                                                              }
    add_check_constraint :reference_values, 'num_nonnulls(node_parameter_id, inline_reference_value_id) = 1',
                         name: check_constraint_name(:reference_values, :owner, :one_of)

    change_column_null :sub_flows, :node_parameter_id, true
    add_reference :sub_flows, :inline_reference_value, null: true, index: { unique: true },
                                                       foreign_key: {
                                                         to_table: :inline_reference_values,
                                                         on_delete: :cascade,
                                                       }
    add_check_constraint :sub_flows, 'num_nonnulls(node_parameter_id, inline_reference_value_id) = 1',
                         name: check_constraint_name(:sub_flows, :owner, :one_of)
  end
end
