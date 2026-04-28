# frozen_string_literal: true

class ChangeLicenseToGlobalObject < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    rename_table :namespace_licenses, :licenses
    change_column_null :licenses, :namespace_id, true
  end
end
