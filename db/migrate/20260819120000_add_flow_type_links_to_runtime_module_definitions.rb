# frozen_string_literal: true

class AddFlowTypeLinksToRuntimeModuleDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_module_definition_flow_type_links do |t|
      t.references :runtime_module_definition, null: false,
                                               foreign_key: { on_delete: :cascade },
                                               index: false
      t.references :flow_type, null: false,
                               foreign_key: { on_delete: :restrict },
                               index: false

      t.index %i[runtime_module_definition_id flow_type_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
