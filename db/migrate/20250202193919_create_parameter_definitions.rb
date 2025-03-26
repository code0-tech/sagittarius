# frozen_string_literal: true

class CreateParameterDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :parameter_definitions do |t|
      t.references :runtime_parameter_definition, null: false, foreign_key: { on_delete: :cascade }
      t.references :data_type, null: false, foreign_key: { on_delete: :restrict }
      t.jsonb :default_value, null: true

      t.timestamps_with_timezone
    end
  end
end
