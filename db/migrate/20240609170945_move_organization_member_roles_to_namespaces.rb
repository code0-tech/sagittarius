# frozen_string_literal: true

class MoveOrganizationMemberRolesToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    rename_table :organization_member_roles, :namespace_member_roles
  end
end
