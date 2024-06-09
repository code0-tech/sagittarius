# frozen_string_literal: true

class MoveOrganizationLicensesToNamespaces < Sagittarius::Database::Migration[1.0]
  # rubocop:disable Rails/NotNullColumn -- backwards compatibility was intentionally ignored
  def change
    remove_reference :organization_licenses, :organization, null: false, foreign_key: { on_delete: :cascade }

    rename_table :organization_licenses, :namespace_licenses

    add_reference :namespace_licenses, :namespace, null: false, foreign_key: { on_delete: :cascade }
  end
  # rubocop:enable Rails/NotNullColumn
end
