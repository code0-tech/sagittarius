# frozen_string_literal: true

class AddRuntimeModuleDefinition < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :runtime_module_definitions do |t|
      t.references :runtime_module, null: false, foreign_key: { on_delete: :cascade }
      t.text :host, null: false, limit: 253
      t.bigint :port, null: false
      t.text :endpoint, null: false, limit: 2048

      t.timestamps_with_timezone
    end
  end
end
