# frozen_string_literal: true

class MoveOrganizationMembersToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    remove_index :organization_members, %i[organization_id user_id],
                 name: 'index_organization_members_on_organization_id_and_user_id', unique: true
    remove_reference :organization_members, :organization,
                     null: false,
                     foreign_key: { to_table: :organizations, on_delete: :cascade }

    rename_table :organization_members, :namespace_members

    add_reference :namespace_members, :namespace, null: false, foreign_key: { on_delete: :cascade }, index: false
    add_index :namespace_members, %i[namespace_id user_id], unique: true
  end
  # rubocop:enable Rails/NotNullColumn
end
