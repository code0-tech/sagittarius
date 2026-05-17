# frozen_string_literal: true

class CreateRuntimeFlowTypes < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    create_table :runtime_flow_types do |t|
      t.references :runtime, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :identifier, null: false, limit: 50
      t.boolean :editable, null: false, default: false
      t.text :signature, null: false, default: '', limit: 500
      t.datetime_with_timezone :removed_at
      t.text :definition_source, limit: 50
      t.text :display_icon, limit: 100
      t.text :version, null: false

      t.index %i[runtime_id identifier], unique: true
      t.index %i[runtime_module_id identifier], unique: true, name: 'idx_rft_on_runtime_module_id_identifier'

      t.timestamps_with_timezone
    end

    create_table :runtime_flow_type_settings do |t|
      t.references :runtime_flow_type, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :identifier, null: false
      t.integer :unique, null: false, default: 0
      t.jsonb :default_value
      t.datetime_with_timezone :removed_at

      t.index %i[runtime_flow_type_id identifier], unique: true, name: 'idx_rft_settings_on_rft_id_identifier'

      t.timestamps_with_timezone
    end

    create_table :runtime_flow_type_data_type_links do |t|
      t.references :runtime_flow_type, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :referenced_data_type, null: false, foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[runtime_flow_type_id referenced_data_type_id],
              unique: true,
              name: 'idx_rft_links_on_rft_id_data_type_id'

      t.timestamps_with_timezone
    end

    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_reference :flow_types, :runtime_flow_type, null: false, foreign_key: { on_delete: :cascade }, index: false
    # rubocop:enable Rails/NotNullColumn

    add_index :flow_types, :runtime_flow_type_id
  end

  def down
    remove_index :flow_types, :runtime_flow_type_id
    remove_reference :flow_types, :runtime_flow_type, foreign_key: { on_delete: :cascade }

    drop_table :runtime_flow_type_data_type_links
    drop_table :runtime_flow_type_settings
    drop_table :runtime_flow_types
  end
end
