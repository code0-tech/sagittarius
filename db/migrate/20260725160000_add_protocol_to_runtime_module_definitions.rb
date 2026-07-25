# frozen_string_literal: true

class AddProtocolToRuntimeModuleDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_module_definitions, :protocol, :text, null: false, limit: 255 # rubocop:disable Rails/NotNullColumn
  end
end
