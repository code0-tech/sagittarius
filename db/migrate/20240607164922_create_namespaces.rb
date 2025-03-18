# frozen_string_literal: true

class CreateNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :namespaces do |t|
      t.references :parent, polymorphic: true, null: false, index: false

      t.index %i[parent_id parent_type], unique: true

      t.timestamps_with_timezone
    end
  end
end
