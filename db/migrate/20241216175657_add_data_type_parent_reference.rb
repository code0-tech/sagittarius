# frozen_string_literal: true

class AddDataTypeParentReference < Sagittarius::Database::Migration[1.0]
  def change
    add_reference :data_types, :parent_type, foreign_key: {
      to_table: :data_types,
      on_delete: :restrict,
    }
  end
end
