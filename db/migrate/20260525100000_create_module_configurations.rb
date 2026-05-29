# frozen_string_literal: true

class CreateModuleConfigurations < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :module_configurations do |t|
      t.references :namespace_project_runtime_assignment,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: { name: 'idx_module_configs_on_assignment_id' }
      t.references :module_configuration_definition,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: { name: 'idx_module_configs_on_definition_id' }
      t.jsonb :value

      t.index %i[namespace_project_runtime_assignment_id module_configuration_definition_id],
              unique: true,
              name: 'idx_module_configs_on_assignment_id_and_definition_id'

      t.timestamps_with_timezone
    end
  end
end
