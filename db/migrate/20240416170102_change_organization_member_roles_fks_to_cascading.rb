# frozen_string_literal: true

class ChangeOrganizationMemberRolesFksToCascading < Sagittarius::Database::Migration[1.0]
  def change
    remove_foreign_key :organization_member_roles, :organization_roles, column: :role_id
    add_foreign_key :organization_member_roles, :organization_roles, column: :role_id, on_delete: :cascade

    remove_foreign_key :organization_member_roles, :organization_members, column: :member_id
    add_foreign_key :organization_member_roles, :organization_members, column: :member_id, on_delete: :cascade
  end
end
