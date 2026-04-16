# frozen_string_literal: true

class ChangeReferencePathFkToCascade < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :reference_paths, :reference_values, on_delete: :restrict

    add_foreign_key :reference_paths, :reference_values, on_delete: :cascade
  end
end
