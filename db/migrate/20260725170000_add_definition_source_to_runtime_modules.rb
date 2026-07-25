# frozen_string_literal: true

class AddDefinitionSourceToRuntimeModules < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :runtime_modules, :definition_source, :text, limit: 50
  end
end
