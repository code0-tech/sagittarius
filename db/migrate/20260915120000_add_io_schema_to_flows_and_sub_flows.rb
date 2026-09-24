# frozen_string_literal: true

class AddIoSchemaToFlowsAndSubFlows < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flows, :input_schema, :jsonb
    add_column :flows, :output_schema, :jsonb
    add_column :sub_flows, :input_schema, :jsonb
    add_column :sub_flows, :output_schema, :jsonb
  end
end
