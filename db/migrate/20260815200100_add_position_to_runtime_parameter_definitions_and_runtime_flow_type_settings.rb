# frozen_string_literal: true

class AddPositionToRuntimeParameterDefinitionsAndRuntimeFlowTypeSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_parameter_definitions, :position, :integer, null: false, default: 0
    add_column :runtime_flow_type_settings, :position, :integer, null: false, default: 0
  end
end
