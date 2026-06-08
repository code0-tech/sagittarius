# frozen_string_literal: true

class UpdateRuntimeStatuses < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    runtime_status_model.delete_all

    remove_column :runtime_statuses, :identifier, :text
    remove_column :runtime_statuses, :status_type, :integer, default: 0, null: false
    remove_index :runtime_statuses, :runtime_id
    add_index :runtime_statuses, :runtime_id, unique: true

    create_table :runtime_module_statuses do |t|
      t.references :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.integer :status, null: false, default: 4
      t.datetime_with_timezone :last_heartbeat

      t.index :runtime_module_id, unique: true

      t.timestamps_with_timezone
    end

    create_table :runtime_module_definitions do |t|
      t.references :runtime_module, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.text :flow_type_identifiers, array: true, null: false, default: []
      t.text :host, null: false
      t.bigint :port, null: false
      t.text :endpoint, null: false

      t.index :runtime_module_id

      t.timestamps_with_timezone
    end
  end

  private

  def runtime_status_model
    @runtime_status_model ||= Class.new(ActiveRecord::Base) do
      self.table_name = 'runtime_statuses'
      self.inheritance_column = :_type_disabled
    end
  end
end
