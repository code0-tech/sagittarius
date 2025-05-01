# frozen_string_literal: true

class AddDefaultValueToRuntimeParameterDefinition < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_parameter_definitions, :default_value, :jsonb
  end
end
