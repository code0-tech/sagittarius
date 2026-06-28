# frozen_string_literal: true

class ChangeRuntimeNamespaceFkToCascade < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :runtimes, :namespaces

    add_foreign_key :runtimes, :namespaces, on_delete: :cascade
  end
end
