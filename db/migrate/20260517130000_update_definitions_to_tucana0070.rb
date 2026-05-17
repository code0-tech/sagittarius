# frozen_string_literal: true

class UpdateDefinitionsToTucana0070 < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_function_definitions, :design, :text, limit: 200
    add_column :function_definitions, :design, :text, limit: 200

    add_column :runtime_parameter_definitions, :optional, :boolean, null: false, default: false
    add_column :runtime_parameter_definitions, :hidden, :boolean, null: false, default: false

    add_column :parameter_definitions, :optional, :boolean, null: false, default: false
    add_column :parameter_definitions, :hidden, :boolean, null: false, default: false

    add_column :flow_type_settings, :optional, :boolean, null: false, default: false
    add_column :flow_type_settings, :hidden, :boolean, null: false, default: false

    add_column :runtime_flow_type_settings, :optional, :boolean, null: false, default: false
    add_column :runtime_flow_type_settings, :hidden, :boolean, null: false, default: false
  end
end
