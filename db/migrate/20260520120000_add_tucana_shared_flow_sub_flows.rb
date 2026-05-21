# frozen_string_literal: true

class AddTucanaSharedFlowSubFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flow_settings, :cast, :text

    add_column :node_parameters, :cast, :text

    create_table :sub_flows do |t|
      t.references :node_parameter, null: false, index: { unique: true },
                                    foreign_key: { to_table: :node_parameters, on_delete: :cascade }
      t.references :starting_node, null: true, foreign_key: { to_table: :node_functions, on_delete: :restrict }
      t.text :function_identifier
      t.text :signature, null: false

      t.check_constraint 'num_nonnulls(starting_node_id, function_identifier) = 1',
                         name: check_constraint_name(:sub_flows, :execution_reference, :one_of)

      t.timestamps_with_timezone
    end

    create_table :sub_flow_settings do |t|
      t.references :sub_flow, null: false, foreign_key: { to_table: :sub_flows, on_delete: :cascade }
      t.text :identifier, null: false
      t.jsonb :default_value
      # rubocop:disable Rails/ThreeStateBooleanColumn -- mirrors proto optional bool presence
      t.boolean :optional
      t.boolean :hidden
      # rubocop:enable Rails/ThreeStateBooleanColumn

      t.timestamps_with_timezone
    end

    remove_reference :node_functions, :value_of_node_parameter,
                     null: true,
                     foreign_key: { to_table: :node_parameters, on_delete: :cascade }
  end
end
