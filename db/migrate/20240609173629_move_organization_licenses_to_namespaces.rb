# frozen_string_literal: true

class MoveOrganizationLicensesToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  # rubocop:disable-next Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    remove_reference :organization_licenses, :organization, null: false, foreign_key: { on_delete: :cascade }

    rename_table :organization_licenses, :namespace_licenses

    add_reference :namespace_licenses, :namespace, null: false, foreign_key: { on_delete: :cascade }
  end
end
