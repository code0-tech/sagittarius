# frozen_string_literal: true

class AllowNullValueInApplicationSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    change_column_null :application_settings, :value, true
  end
end
