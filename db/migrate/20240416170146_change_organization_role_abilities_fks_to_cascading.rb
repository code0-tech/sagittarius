# frozen_string_literal: true

class ChangeOrganizationRoleAbilitiesFksToCascading < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :organization_role_abilities, :organization_roles
    add_foreign_key :organization_role_abilities, :organization_roles, on_delete: :cascade
  end
end
