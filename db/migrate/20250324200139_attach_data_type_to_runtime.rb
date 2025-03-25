# frozen_string_literal: true

class AttachDataTypeToRuntime < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
    add_reference :data_types, :runtime, foreign_key: { on_delete: :cascade }, index: false, null: false
    add_index :data_types, %i[runtime_id identifier], unique: true

    remove_index :data_types, %i[namespace_id identifier], unique: true
    remove_reference :data_types, :namespace, index: false, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
