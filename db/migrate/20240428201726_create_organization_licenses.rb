# frozen_string_literal: true

class CreateOrganizationLicenses < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :organization_licenses do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }
      t.text :data, null: false

      t.timestamps_with_timezone
    end
  end
end
