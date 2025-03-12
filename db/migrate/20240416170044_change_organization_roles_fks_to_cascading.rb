# frozen_string_literal: true

class ChangeOrganizationRolesFksToCascading < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :organization_roles, :organizations
    add_foreign_key :organization_roles, :organizations, on_delete: :cascade
  end
end
