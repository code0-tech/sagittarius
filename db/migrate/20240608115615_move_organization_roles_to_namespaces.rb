# frozen_string_literal: true

class MoveOrganizationRolesToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    rename_table :organization_roles, :namespace_roles

    add_reference :namespace_roles, :namespace, null: false, foreign_key: { on_delete: :cascade }, index: false
    add_index :namespace_roles, '"namespace_id", LOWER("name")', unique: true

    remove_index :namespace_roles, '"organization_id", LOWER("name")',
                 name: 'index_organization_roles_on_organization_id_LOWER_name', unique: true
    remove_reference :namespace_roles, :organization, null: false, foreign_key: { on_delete: :cascade }
  end
  # rubocop:enable Rails/NotNullColumn
end
