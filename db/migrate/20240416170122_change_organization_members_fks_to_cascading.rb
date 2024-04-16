# frozen_string_literal: true

class ChangeOrganizationMembersFksToCascading < Sagittarius::Database::Migration[1.0]
  def change
    remove_foreign_key :organization_members, :users
    add_foreign_key :organization_members, :users, on_delete: :cascade

    remove_foreign_key :organization_members, :organizations
    add_foreign_key :organization_members, :organizations, on_delete: :cascade
  end
end
