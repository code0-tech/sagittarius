# frozen_string_literal: true

class ReplaceSubFlowSettingsWithParameters < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :sub_flows, :name, :text, limit: 255
    add_column :sub_flows, :description, :text, limit: 1000

    # SubFlowSetting (identifier/default_value/optional/hidden) became
    # SubFlowParameters (identifier/value/cast), where `value` is a NodeValue.
    rename_table :sub_flow_settings, :sub_flow_parameters

    remove_column :sub_flow_parameters, :default_value, :jsonb
    remove_column :sub_flow_parameters, :optional, :boolean, null: false, default: false
    remove_column :sub_flow_parameters, :hidden, :boolean, null: false, default: false

    add_column :sub_flow_parameters, :cast, :text, limit: 500
    add_column :sub_flow_parameters, :literal_value, :jsonb

    # A sub-flow parameter now owns a NodeValue, so it joins node_parameter and
    # inline_reference_value as a possible owner of reference/sub-flow/inline values.
    add_reference :reference_values, :sub_flow_parameter, null: true,
                                                          foreign_key: {
                                                            to_table: :sub_flow_parameters, on_delete: :cascade
                                                          }
    remove_check_constraint :reference_values,
                            name: check_constraint_name(:reference_values, :owner, :one_of)
    add_check_constraint :reference_values,
                         'num_nonnulls(node_parameter_id, inline_reference_value_id, sub_flow_parameter_id) = 1',
                         name: check_constraint_name(:reference_values, :owner, :one_of)

    add_reference :inline_reference_values, :sub_flow_parameter, null: true,
                                                                 foreign_key: {
                                                                   to_table: :sub_flow_parameters, on_delete: :cascade
                                                                 }
    remove_check_constraint :inline_reference_values,
                            name: check_constraint_name(:inline_reference_values, :owner, :one_of)
    add_check_constraint :inline_reference_values,
                         'num_nonnulls(node_parameter_id, parent_inline_reference_value_id, sub_flow_parameter_id) = 1',
                         name: check_constraint_name(:inline_reference_values, :owner, :one_of)

    add_reference :sub_flows, :sub_flow_parameter, null: true, index: { unique: true },
                                                   foreign_key: {
                                                     to_table: :sub_flow_parameters, on_delete: :cascade
                                                   }
    remove_check_constraint :sub_flows,
                            name: check_constraint_name(:sub_flows, :owner, :one_of)
    add_check_constraint :sub_flows,
                         'num_nonnulls(node_parameter_id, inline_reference_value_id, sub_flow_parameter_id) = 1',
                         name: check_constraint_name(:sub_flows, :owner, :one_of)
  end
end
