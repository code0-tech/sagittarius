# frozen_string_literal: true

class AddDefinitionSourceAndDisplayIcon < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_function_definitions, :definition_source, :text, limit: 50
    add_column :runtime_function_definitions, :display_icon, :text, limit: 100

    add_column :data_types, :definition_source, :text, limit: 50

    add_column :flow_types, :definition_source, :text, limit: 50
    add_column :flow_types, :display_icon, :text, limit: 100
  end
end
