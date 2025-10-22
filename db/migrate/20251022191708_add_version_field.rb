# frozen_string_literal: true

class AddVersionField < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_column :data_types, :version, :text, null: false
    add_column :runtime_function_definitions, :version, :text, null: false
    add_column :flow_types, :version, :text, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
