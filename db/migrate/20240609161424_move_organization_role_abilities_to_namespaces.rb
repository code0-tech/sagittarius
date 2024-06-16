# frozen_string_literal: true

class MoveOrganizationRoleAbilitiesToNamespaces < Sagittarius::Database::Migration[1.0]
  # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    rename_table :organization_role_abilities, :namespace_role_abilities

    add_reference :namespace_role_abilities, :namespace_role,
                  null: false,
                  foreign_key: { on_delete: :cascade },
                  index: false
    add_index :namespace_role_abilities, %i[namespace_role_id ability], unique: true

    remove_index :namespace_role_abilities, %i[organization_role_id ability], unique: true
    remove_reference :namespace_role_abilities, :organization_role,
                     null: false,
                     foreign_key: { to_table: :namespace_roles, on_delete: :cascade }
  end
  # rubocop:enable Rails/NotNullColumn
end
