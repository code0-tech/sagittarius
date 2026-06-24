# frozen_string_literal: true

class IncreaseTypeDefinitionLimits < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    change_column :data_types, :type, :text, null: false, limit: 8192
    change_column :module_configuration_definitions, :type, :text, null: false, limit: 8192
  end
end
