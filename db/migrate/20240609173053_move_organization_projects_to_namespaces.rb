# frozen_string_literal: true

class MoveOrganizationProjectsToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    remove_reference :organization_projects, :organization, null: false, foreign_key: { on_delete: :cascade }

    rename_table :organization_projects, :namespace_projects

    add_reference :namespace_projects, :namespace, null: false, foreign_key: { on_delete: :cascade }
  end
  # rubocop:enable Rails/NotNullColumn
end
